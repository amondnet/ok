import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:okhttp/okhttp.dart';
import 'package:okhttp/src/internal/http_method.dart';

import '../../interceptor.dart';
import '../../ok_http_client.dart';
import '../../request.dart';
import '../../response.dart';
import '../../response_body.dart';

class CallServerInterceptor implements Interceptor {
  CallServerInterceptor(
    OkHttpClient client,
  ) : _client = client;

  final OkHttpClient _client;

  @override
  Future<Response> intercept(Chain chain) async {
    var httpClient = _client.securityContext != null
        ? Http2Client(
            context: _client.securityContext,
            timeout: _client.connectionTimeout,
            autoUncompress: true,
          )
        : Http2Client(timeout: _client.connectionTimeout, autoUncompress: true);
    //httpClient.idleTimeout = _client.idleTimeout();
    //httpClient.connectionTimeout = _client.connectionTimeout();

    if (_client.proxy != null) {
      //httpClient.findProxy = _client.proxy();
    } else if (_client.proxySelector != null) {
      //httpClient.findProxy = await _client.proxySelector().select();
    }

    var request = chain.request();

    var sentRequestMillis = DateTime.now().millisecondsSinceEpoch;
    var streamedRequest = http.StreamedRequest(request.method, request.url);

    streamedRequest.maxRedirects = _client.maxRedirects;
    streamedRequest.followRedirects = _client.followRedirects;
    streamedRequest.contentLength = request.body?.contentLength;
    streamedRequest.persistentConnection =
        request.header(HttpHeaders.connectionHeader)?.toLowerCase() ==
            'keep-alive';
    streamedRequest.headers.addAll(request.headers.toMap());
    if (HttpMethod.permitsRequestBody(request.method) && request.body != null) {
      await streamedRequest.sink.add(await request.body.source().first);
    }

    var httpResponse = await httpClient.send(streamedRequest);

    var responseBuilder = ResponseBuilder();
    responseBuilder.code(httpResponse.statusCode);
    responseBuilder.message(httpResponse.reasonPhrase);

    if (httpResponse.headers != null) {
      httpResponse.headers.forEach((String name, String value) {
        responseBuilder.addHeader(name, value);
      });
    }
    var response = responseBuilder
        .request(request)
        .sentRequestAtMillis(sentRequestMillis)
        .receivedResponseAtMillis(DateTime.now().millisecondsSinceEpoch)
        .build();

    /*
    var source = StreamTransformer<List<int>, List<int>>.fromHandlers(
        handleDone: (EventSink<List<int>> sink) {
      sink.close();
      // httpClient.close(); // keep alive
    }).bind(httpResponse.stream);
*/
    var contentType = response.header(HttpHeaders.contentTypeHeader);
    response = response
        .newBuilder()
        .body(ResponseBody.streamBody(
            contentType != null ? MediaType.parse(contentType) : null,
            httpResponse.contentLength,
            httpResponse.stream))
        .build();

    if ((response.code == HttpStatus.noContent ||
            response.code == HttpStatus.resetContent) &&
        response.body != null &&
        response.body.contentLength > 0) {
      throw HttpException(
        'HTTP ${response.code} had non-zero Content-Length: ${response.body.contentLength}',
        uri: request.url,
      );
    }
    return response;
  }
}
