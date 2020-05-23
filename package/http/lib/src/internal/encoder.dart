import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import '../media_type.dart';

class Encoder {
  Encoder._();

  static Encoding encoding(MediaType contentTYpe,
      [Encoding defaultValue = utf8]) {
    return Encoding.getByName(contentTYpe?.charset ?? 'utf-8');
  }
}
