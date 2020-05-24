import 'package:okhttp/okhttp.dart';
import 'package:test/test.dart';

void main() {
  test('charset test', () {
    var contentType = MediaTypes.get('application/json; charset=utf-8');
    expect(contentType.charset(), 'utf-8');
  });
}
