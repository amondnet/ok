import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';
import 'package:ok_http/ok_http.dart';

void main() {
  test('charset test', () {
    var contentType = MediaType.parse('application/json; charset=utf-8');
    expect(contentType.charset, 'utf-8');
  });
}
