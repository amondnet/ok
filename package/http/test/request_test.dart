import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ok_http/src/cache_control.dart';
import 'package:ok_http/src/internal/buffer.dart';
import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/request_body.dart';
import 'package:ok_http/ok_http.dart';

import 'package:ok_http/src/response_body.dart';
import 'package:test/test.dart';

void main() {
  group('RequestBodyy', () {
    test('string', () async {
      var contentType = MediaTypes.get('text/plain; charset=utf-8');
      var body = RequestBody.bytesBody(contentType, utf8.encode('abc'));
      expect(body.contentType, contentType);
      expect(body.contentLength, 3);
      expect(await _bodyToHex(body), '616263');
    });

    test('stringWithDefaultCharsetAdded', () async {
      var contentType = MediaTypes.get('text/plain');

      var body = RequestBody.textBody(contentType, '\u0800');
      expect(body.contentType, MediaTypes.get('text/plain; charset=utf-8'));
      expect(body.contentLength, 3);
      expect(await _bodyToHex(body), 'e0a080');
    });

    /* dart not support utf-16
    test('stringWithNonDefaultCharsetSpecified', () async {
      var contentType = MediaTypes.get('text/plain; charset=utf-16be');

      var body = RequestBody.textBody(contentType, '\u0800');
      expect(body.contentType, contentType);
      expect(body.contentLength, 2);
      expect(await _bodyToHex(body), '0800');
    });*/
    test('byteArray', () async {
      var contentType = MediaTypes.get('text/plain');

      var body = RequestBody.bytesBody(contentType, utf8.encode('abc'));
      expect(body.contentType, contentType);
      expect(body.contentLength, 3);
      expect(await _bodyToHex(body), '616263');
    });

    // TODO
    /*
    test('byteArrayRange', () async {
      var contentType = MediaTypes.get('text/plain');

      var body = RequestBody.bytesBody(contentType, utf8.encode('abc'));
      expect(body.contentType, contentType);
      expect(body.contentLength, 3);
      expect(await _bodyToHex(body), '616263');
    });*/

    test('file', () async {
      var file = File('/tmp/RequestTest');
      file.writeAsStringSync('abc');

      var contentType = MediaTypes.get('text/plain');

      var body = RequestBody.fileBody(contentType, file);
      expect(body.contentType, contentType);
      expect(body.contentLength, 3);
      expect(await _bodyToHex(body), '616263');
    });

    /** Common verbs used for apis such as GitHub, AWS, and Google Cloud. */
    test('crudVerbs', () async {
      var contentType = MediaTypes.get('application/json');
      var body = RequestBody.textBody(contentType, '{}');

      var get = RequestBuilder().url('http://localhost/api').get().build();
      expect(get.method, 'GET');
      expect(get.body, isNull);

      var head = RequestBuilder().url('http://localhost/api').head().build();
      expect(head.method, 'HEAD');
      expect(head.body, isNull);

      var delete =
          RequestBuilder().url('http://localhost/api').delete(body).build();
      expect(delete.method, 'DELETE');
      expect(delete.body, body);

      var post =
          RequestBuilder().url('http://localhost/api').post(body).build();
      expect(post.method, 'POST');
      expect(post.body, body);

      var put = RequestBuilder().url('http://localhost/api').put(body).build();
      expect(put.method, 'PUT');
      expect(put.body, body);

      var patch =
          RequestBuilder().url('http://localhost/api').patch(body).build();
      expect(patch.method, 'PATCH');
      expect(patch.body, body);
    });

    test('uninitializedURI', () async {
      var request = RequestBuilder().url('http://localhost/api').build();
      expect(request.url, Uri.parse('http://localhost/api'));
    });

    test('newBuilderUrlResetsUrl', () async {
      var requestWithoutCache =
          RequestBuilder().url('http://localhost/api').build();
      var builtRequestWithoutCache = requestWithoutCache
          .newBuilder()
          .url('http://localhost/api/foo')
          .build();
      expect(
          builtRequestWithoutCache.url, Uri.parse('http://localhost/api/foo'));
    });

    test('cacheControl', () async {
      var request = RequestBuilder()
          .cacheControl(CacheControlBuilder().noCache().build())
          .url('https://square.com')
          .build();
      expect(request.headersByName('Cache-Control'), contains('no-cache'));
      expect(request.cacheControl.noCache, isTrue);
    });

    test('emptyCacheControlClearsAllCacheControlHeaders', () async {
      var request = RequestBuilder()
          .header('Cache-Control', 'foo')
          .cacheControl(CacheControlBuilder().build())
          .url('https://square.com')
          .build();
      expect(request.headersByName('Cache-Control'), isEmpty);
    });

    test('headerAcceptsPermittedCharacters', () async {
      var builder = RequestBuilder();
      builder.header('AZab09~', 'AZab09 ~');
      builder.addHeader('AZab09~', 'AZab09 ~');
    });

    test('emptyNameForbidden', () async {
      var builder = RequestBuilder();
      expect(() => builder.header('', 'value'), throwsArgumentError);
      expect(() => builder.addHeader('', 'value'), throwsArgumentError);
    });

    test('headerForbidsNullArguments', () async {
      var builder = RequestBuilder();
      expect(() => builder.header(null, 'value'), throwsArgumentError);
      expect(() => builder.addHeader(null, 'value'), throwsArgumentError);
      expect(() => builder.header('Name', null), throwsArgumentError);
      expect(() => builder.addHeader('Name', null), throwsArgumentError);
    });

    test('headerAllowsTabOnlyInValues', () async {
      var builder = RequestBuilder();
      builder.header("key", "sample\tvalue");

      expect(() => builder.header('sample\tkey', 'value'), throwsArgumentError);
    });

    test('headerForbidsControlCharacters', () async {
      _assertForbiddenHeader("\u0000");
      _assertForbiddenHeader("\r");
      _assertForbiddenHeader("\n");
      _assertForbiddenHeader("\u001f");
      _assertForbiddenHeader("\u007f");
      _assertForbiddenHeader("\u0080");
      _assertForbiddenHeader("\ud83c\udf69");
    });
  });
}

Future<String> _bodyToHex(RequestBody body) async {
  var string = await readAsBytes(body.source());
  return hex.encode(string);
}

void _assertForbiddenHeader(String s) {
  var builder = RequestBuilder();

  expect(() => builder.header(s, "Value"), throwsArgumentError);
  expect(() => builder.addHeader(s, "Value"), throwsArgumentError);
  expect(() => builder.header('Name', s), throwsArgumentError);
  expect(() => builder.addHeader('Name', s), throwsArgumentError);
}
