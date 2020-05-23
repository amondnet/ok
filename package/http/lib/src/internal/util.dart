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
}
