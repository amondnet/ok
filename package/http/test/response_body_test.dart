import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:okhttp/okhttp.dart';
import 'package:okhttp/src/internal/buffer.dart';
import 'package:okhttp/src/request_body.dart';
import 'package:okhttp/src/response_body.dart';
import 'package:test/test.dart';

void main() {
  group('Response Body', () {
    test('stringEmpty', () async {
      var body = _body('');
      expect(await body.string, '');
    });

    test('stringLooksLikeBomButTooShort', () async {
      var body = _body('000048');
      expect(await body.string, '\x00\x00H');
    });

    test("byteString", () async {
      var contentType = MediaTypes.get('text/plain');
      var body = RequestBody.bytesBody(contentType, utf8.encode('Hello'));
      expect(body.contentType, contentType);
      expect(body.contentLength, 5);
      expect(await _bodyToHex(body), '48656c6c6f');
    });
  });
}

ResponseBody _body(String hex) {
  return _body2(hex, null);
}

ResponseBody _body2(String hexString, String charset) {
  var mediaType =
      charset == null ? null : MediaTypes.get('any/thing; charset=' + charset);

  return ResponseBody.bytesBody(mediaType, hex.decode(hexString));
}

Future<String> _bodyToHex(RequestBody body) async {
  var string = await readAsBytes(body.source());
  return hex.encode(string);
}
