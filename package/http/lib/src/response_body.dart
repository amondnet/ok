import 'dart:async';

import 'package:http_parser/http_parser.dart';
import 'package:ok_http/src/internal/encoder.dart';

import 'internal/buffer.dart';
import 'media_types.dart';

abstract class ResponseBody {
  MediaTypes get contentType;

  int get contentLength;

  Stream<List<int>> get source;

  static ResponseBody bytesBody(MediaType contentType, List<int> bytes) {
    return streamBody(contentType, bytes.length,
        Stream<List<int>>.fromIterable(<List<int>>[bytes]));
  }

  static ResponseBody streamBody(
      MediaType contentType, int contentLength, Stream<List<int>> source) {
    return _StreamResponseBody(contentType, contentLength, source);
  }

  Future<List<int>> get bytes {
    return readAsBytes(source);
  }

  Future<String> get string async {
    var encoding = Encoder.encoding(contentType);
    return encoding.decode(await bytes);
  }
}

class _StreamResponseBody extends ResponseBody {
  _StreamResponseBody(this._contentType, this._contentLength, this._source);

  final MediaTypes _contentType;
  final int _contentLength;
  final Stream<List<int>> _source;

  @override
  MediaTypes get contentType {
    return _contentType;
  }

  @override
  int get contentLength {
    return _contentLength;
  }

  @override
  Stream<List<int>> get source {
    return _source;
  }
}
