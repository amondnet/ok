import 'dart:async';

import 'dart:convert';

extension StringExtenstions on String {
  /// Returns the index of the next non-whitespace character in this. Result is undefined if input
  /// contains newline characters.
  int indexOfNonWhitespace([int startIndex = 0]) {
    for (var i = startIndex; i < length; i++) {
      var c = this[i];
      if (c != ' ' && c != '\t') {
        return i;
      }
    }
    return length;
  }

  /// Increments [startIndex] until this string is not ASCII whitespace. Stops at [endIndex].
  int indexOfFirstNonAsciiWhitespace([int startIndex = 0, int endIndex]) {
    endIndex ??= length;
    var index = indexOf(RegExp(r'[\t\n\u000c\r\s]'));
    if (index == -1) return endIndex;
    return index;
  }
}

/*
Future<List<int>> readAsBytes(Stream<List<int>> source) {
  var completer = Completer<List<int>>();
  var sink = ByteConversionSink.withCallback((List<int> accumulated) {
    completer.complete(accumulated);
  });
  source.listen(
    sink.add,
    onError: completer.completeError,
    onDone: sink.close,
    cancelOnError: true,
  );
  return completer.future;
}
*/
