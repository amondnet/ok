import 'dart:convert';

import 'package:ok_http/ok_http.dart';
import 'package:ok_http/src/protocol.dart';
import 'package:ok_http/src/request.dart';
import 'package:ok_http/src/response.dart';
import 'package:ok_http/src/response_body.dart';
import 'package:test/test.dart';

void main() {
  group('Response', () {
    test('peekShorterThanResponse', () async {
      var response = _newResponseOk(_StringResponseBody('abcdef'));
      var peekedBody = await response.peekBody(3);
      expect(await peekedBody.string, 'abc');
      expect(await response.body.string, 'abcdef');
    });

    test('peekLongerThanResponse', () async {
      var response = _newResponseOk(_StringResponseBody('abc'));
      var peekedBody = await response.peekBody(6);
      expect(await peekedBody.string, 'abc');
      expect(await response.body.string, 'abc');
    });

    // TODO
    /*
    test('peekAfterReadingResponse', () async {
      var response = _newResponseOk(_StringResponseBody('abc'));
      expect(await response.body.string, 'abc');
      expect(() async => await response.peekBody(3), throwsException);
    });*/

    test('eachPeakIsIndependent', () async {
      var response = _newResponseOk(_StringResponseBody('abcdef'));
      var p1 = await response.peekBody(4);
      var p2 = await response.peekBody(2);
      expect(await response.body.string, 'abcdef');
      expect(await p1.string, 'abcd');
      expect(await p2.string, 'ab');
    });

    test('negativeStatusCodeThrowsIllegalStateException', () async {
      expect(() => _newResponse(_StringResponseBody('set status code -1'), -1),
          throwsStateError);
    });

    test('zeroStatusCodeIsValid', () async {
      var response = _newResponse(_StringResponseBody('set status code 0'), 0);
      expect(response.code, 0);
    });
  });
}

class _StringResponseBody implements ResponseBody {
  final String content;

  _StringResponseBody(this.content);

  @override
  int get contentLength => content.length;

  @override
  MediaTypes get contentType => MediaTypes.get('plain/text');

  @override
  Stream<List<int>> get source => Stream.value(utf8.encode(content));

  @override
  Future<List<int>> get bytes => Future.value(utf8.encode(content));

  @override
  Future<String> get string => Future.value(content);
}

Response _newResponseOk(ResponseBody responseBody) {
  return _newResponse(responseBody, 200);
}

Response _newResponse(ResponseBody responseBody, int code) {
  return Response.builder()
      .request(Request.builder().uri(Uri.parse('https://example.com/')).build())
      .protocol(Protocol.HTTP_1_1)
      .code(code)
      .message('OK')
      .body(responseBody)
      .build();
}
