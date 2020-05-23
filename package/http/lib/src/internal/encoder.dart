import 'dart:convert';

import '../media_types.dart';

class Encoder {
  Encoder._();

  static Encoding encoding(MediaTypes contentType,
      [Encoding defaultValue = utf8]) {
    return Encoding.getByName(contentType?.charset()) ?? defaultValue;
  }
}
