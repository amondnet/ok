import 'package:test/test.dart';
import 'package:okhttp/okhttp.dart';

void main() {
  test('indexOfFirstNonAsciiWhitespace \t', () {
    var indexOfFirstNonAsciiWhitespace =
        'abcd\t'.indexOfFirstNonAsciiWhitespace();
    expect(indexOfFirstNonAsciiWhitespace, 4);
  });

  test('indexOfFirstNonAsciiWhitespace \n', () {
    var indexOfFirstNonAsciiWhitespace =
        'abcd\n'.indexOfFirstNonAsciiWhitespace();
    expect(indexOfFirstNonAsciiWhitespace, 4);
  });

  test('indexOfFirstNonAsciiWhitespace \r', () {
    var indexOfFirstNonAsciiWhitespace =
        'abcd\r'.indexOfFirstNonAsciiWhitespace();
    expect(indexOfFirstNonAsciiWhitespace, 4);
  });

  test('indexOfFirstNonAsciiWhitespace \u000c', () {
    var indexOfFirstNonAsciiWhitespace =
        'abcd\u000c'.indexOfFirstNonAsciiWhitespace();
    expect(indexOfFirstNonAsciiWhitespace, 4);
  });
}
