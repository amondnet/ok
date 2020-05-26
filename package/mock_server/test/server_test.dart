/*
 * Copyright (C) 2017 Miguel Castiblanco
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ok_mock_server/ok_mock_server.dart';
import 'package:resource/resource.dart' show Resource;
import 'package:test/test.dart';

MockServer _server;

void main() {
  setUp(() {
    _server = MockServer();
    _server.start();
  });

  tearDown(() async {
    await _server.shutdown();
  });

  test('Set response code', () async {
    _server.enqueue(httpCode: 401);
    HttpClientResponse response = await _get('');
    expect(response.statusCode, 401);
  });

  test('Set body', () async {
    _server.enqueue(body: 'something');
    HttpClientResponse response = await _get('');
    expect(await _read(response), 'something');
  });

  test('Set headers', () async {
    var headers = <String, String>{};
    headers['X-Server'] = 'MockDart';

    _server.enqueue(body: 'Created', httpCode: 201, headers: headers);
    HttpClientResponse response = await _get('');
    expect(response.statusCode, 201);
    expect(response.headers.value('X-Server'), 'MockDart');
    expect(await _read(response), 'Created');
  });

  test('Set body and response code', () async {
    _server.enqueue(body: 'Created', httpCode: 201);
    HttpClientResponse response = await _get('');
    expect(response.statusCode, 201);
    expect(await _read(response), 'Created');
  });

  test('Set body, response code, and headers', () async {
    Map<String, String> headers = Map();
    headers['X-Server'] = 'MockDart';

    _server.enqueue(body: 'Created', httpCode: 201, headers: headers);
    HttpClientResponse response = await _get('');
    expect(response.statusCode, 201);
    expect(response.headers.value('X-Server'), 'MockDart');
    expect(await _read(response), 'Created');
  });

  test('Queue', () async {
    _server.enqueue(body: 'hello');
    _server.enqueue(body: 'world');
    HttpClientResponse response = await _get('');
    expect(await _read(response), 'hello');

    response = await _get('');
    expect(await _read(response), 'world');
  });

  test('Take requests & request count', () async {
    _server.enqueue(body: 'a');
    _server.enqueue(body: 'b');
    _server.enqueue(body: 'c');
    await _get('first');
    await _get('second');
    await _get('third');

    expect(_server.takeRequest().uri.path, '/first');
    expect(_server.takeRequest().uri.path, '/second');
    expect(_server.takeRequest().uri.path, '/third');
    expect(_server.requestCount, 3);
  });

  test('Request count', () async {
    _server.enqueue(httpCode: HttpStatus.unauthorized);

    await _get('first');

    expect(_server.takeRequest().uri.path, '/first');
    expect(_server.requestCount, 1);
  });

  test('Dispatcher', () async {
    var dispatcher = (HttpRequest request) async {
      if (request.uri.path == '/users') {
        return MockResponse()
          ..httpCode = 200
          ..body = 'working';
      } else if (request.uri.path == '/users/1') {
        return MockResponse()..httpCode = 201;
      } else if (request.uri.path == '/delay') {
        return MockResponse()
          ..httpCode = 200
          ..delay = Duration(milliseconds: 1500);
      }

      return MockResponse()..httpCode = 404;
    };

    _server.dispatcher = dispatcher;

    HttpClientResponse response = await _get('unknown');
    expect(response.statusCode, 404);

    response = await _get('users');
    expect(response.statusCode, 200);
    expect(await _read(response), 'working');

    response = await _get('users/1');
    expect(response.statusCode, 201);

    var stopwatch = Stopwatch()..start();
    response = await _get('delay');
    stopwatch.stop();
    expect(stopwatch.elapsed.inMilliseconds,
        greaterThanOrEqualTo(Duration(milliseconds: 1500).inMilliseconds));
    expect(response.statusCode, 200);
  });

  test('Enqueue MockResponse', () async {
    var headers = <String, String>{};
    headers['X-Server'] = 'MockDart';

    var mockResponse = MockResponse()
      ..httpCode = 201
      ..body = 'Created'
      ..headers = headers;

    _server.enqueueResponse(mockResponse);
    HttpClientResponse response = await _get('');
    expect(response.statusCode, 201);
    expect(response.headers.value('X-Server'), 'MockDart');
    expect(await _read(response), 'Created');
  });

  test('Delay', () async {
    _server.enqueue(delay: Duration(seconds: 2), httpCode: 201);
    var stopwatch = Stopwatch()..start();
    HttpClientResponse response = await _get('');

    stopwatch.stop();
    expect(stopwatch.elapsed.inMilliseconds,
        greaterThanOrEqualTo(Duration(seconds: 2).inMilliseconds));
    expect(response.statusCode, 201);
  });

  test('Parallel delay', () async {
    var body70 = '70 milliseconds';
    var body40 = '40 milliseconds';
    var body20 = '20 milliseconds';
    _server.enqueue(delay: Duration(milliseconds: 40), body: body40);
    _server.enqueue(delay: Duration(milliseconds: 70), body: body70);
    _server.enqueue(delay: Duration(milliseconds: 20), body: body20);

    var completer = Completer();
    var responses = <String>[];

    _get('').then((res) async {
      // 40 milliseconds
      var result = await _read(res);
      responses.add(result);
    });

    _get('').then((res) async {
      // 70 milliseconds
      var result = await _read(res);
      responses.add(result);

      // complete on the longer operation
      completer.complete();
    });

    _get('').then((res) async {
      // 20 milliseconds
      var result = await _read(res);
      responses.add(result);
    });

    await completer.future;

    // validate that the responses happened in order 20, 40, 70
    expect(responses[0], body20);
    expect(responses[1], body40);
    expect(responses[2], body70);
  });

  test('Request specific port IPv4', () async {
    var _server = MockServer(port: 8029);
    await _server.start();

    var url = RegExp(r'(?:http[s]?:\/\/(?:127\.0\.0\.1):8029\/)');
    var host = RegExp(r'(?:127\.0\.0\.1)');

    expect(url.hasMatch(_server.url), true);
    expect(host.hasMatch(_server.host), true);
    expect(_server.port, 8029);

    await _server.shutdown();
  });

  test('Request specific port IPv6', () async {
    var _server = MockServer(port: 8030, addressType: InternetAddressType.IPv6);
    await _server.start();

    var url = RegExp(r'(?:http[s]?:\/\/(?:::1):8030\/)');
    var host = RegExp(r'(?:::1)');

    expect(url.hasMatch(_server.url), true);
    expect(host.hasMatch(_server.host), true);
    expect(_server.port, 8030);

    await _server.shutdown();
  });

  test('TLS info', () async {
    var chainRes = Resource('test/resource/server_chain.pem');
    var chain = await chainRes.readAsBytes();

    var keyRes = Resource('test/resource/server_key.pem');
    var key = await keyRes.readAsBytes();

    var certificate = Certificate()
      ..password = 'dartdart'
      ..key = key
      ..chain = chain;

    var _server = MockServer(port: 8029, certificate: certificate);
    await _server.start();

    var url = RegExp(r'(?:https:/\/(?:127\.0\.0\.1):8029/)');
    var host = RegExp(r'(?:127\.0\.0\.1)');

    expect(url.hasMatch(_server.url), true);
    expect(host.hasMatch(_server.host), true);
    expect(_server.port, 8029);

    await _server.shutdown();
  });

  test('TLS cert', () async {
    var body = 'S03E08 You Are Not Safe';

    var chainRes = Resource('test/resource/server_chain.pem');
    var chain = await chainRes.readAsBytes();

    var keyRes = Resource('test/resource/server_key.pem');
    var key = await keyRes.readAsBytes();

    var certificate = Certificate()
      ..password = 'dartdart'
      ..key = key
      ..chain = chain;

    var _server = MockServer(port: 8029, certificate: certificate);
    await _server.start();
    _server.enqueue(body: body);

    var certRes = Resource('test/resource/trusted_certs.pem');
    var cert = await certRes.readAsBytes();

    // Calling without the proper security context
    var clientErr = HttpClient();

    expect(clientErr.getUrl(Uri.parse(_server.url)),
        throwsA(TypeMatcher<HandshakeException>()));

    // Testing with security context
    var clientContext = SecurityContext()..setTrustedCertificatesBytes(cert);

    var client = HttpClient(context: clientContext);
    var request = await client.getUrl(Uri.parse(_server.url));
    var response = await _read(await request.close());

    expect(response, body);

    await _server.shutdown();
  });

  test('Check take request', () async {
    _server.enqueue();

    var client = HttpClient();
    var request = await client.post(_server.host, _server.port, 'test');
    request.headers.add('x-header', 'nosniff');
    request.write('sample body');

    await request.close();
    var storedRequest = _server.takeRequest();

    expect(storedRequest.method, 'POST');
    expect(storedRequest.body, 'sample body');
    expect(storedRequest.uri.path, '/test');
    expect(storedRequest.headers['x-header'], 'nosniff');
  });

  test('default response', () async {
    _server.defaultResponse = MockResponse()..httpCode = 404;

    var response = await _get('');
    expect(response.statusCode, 404);
  });
}

_get(String path) async {
  var client = HttpClient();
  var request = await client.get(_server.host, _server.port, path);
  return await request.close();
}

Future<String> _read(HttpClientResponse response) async {
  var body = StringBuffer();
  var completer = Completer<String>();

  response.transform(utf8.decoder).listen((data) {
    body.write(data);
  }, onDone: () {
    completer.complete(body.toString());
  });

  await completer.future;
  return body.toString();
}
