import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:quiver/check.dart';

import 'internal/encoder.dart';
import 'media_types.dart';

abstract class RequestBody {
  MediaTypes get contentType;

  int get contentLength;

  Stream<List<int>> source();

  static RequestBody bytesBody(MediaType contentType, List<int> bytes,
      [int offset = 0, int byteCount]) {
    checkNotNull(bytes);
    return _SimpleRequestBody(contentType, bytes.length, bytes);
  }

  static RequestBody textBody(MediaType contentType, String text) {
    checkNotNull(text);
    var encoding = Encoder.encoding(contentType);
    return bytesBody(contentType, encoding.encode(text));
  }

  static RequestBody fileBody(MediaType contentType, File file) {
    return _FileRequestBody(contentType, file);
  }
}

class _SimpleRequestBody extends RequestBody {
  _SimpleRequestBody(
    MediaType contentType,
    int contentLength,
    List<int> bytes,
  )   : _contentType = contentType,
        _contentLength = contentLength,
        _bytes = bytes;

  final MediaTypes _contentType;
  final int _contentLength;
  final List<int> _bytes;

  @override
  MediaTypes get contentType {
    return _contentType;
  }

  @override
  int get contentLength {
    return _contentLength;
  }

  @override
  Stream<List<int>> source() {
    return Stream<List<int>>.fromIterable(<List<int>>[_bytes]);
  }
}

class _FileRequestBody extends RequestBody {
  _FileRequestBody(
    MediaType contentType,
    File file,
  )   : _contentType = contentType,
        _file = file;

  final MediaTypes _contentType;
  final File _file;

  @override
  MediaTypes get contentType {
    return _contentType;
  }

  @override
  int get contentLength {
    return _file.lengthSync();
  }

  @override
  Stream<List<int>> source() {
    return _file.openRead();
  }
}
