import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';

import 'headers.dart';
import 'internal/cache/cache_strategy.dart';
import 'internal/http_method.dart';
import 'request.dart';
import 'response.dart';

class Cache {
  Cache(RawCache cache, [
    KeyExtractor keyExtractor,
  ])
      : assert(cache != null),
        _cache = cache,
        _keyExtractor = keyExtractor ?? _defaultKeyExtractor;

  static const int version = 201105;
  static const int entryMetaData = 0;
  static const int entryBody = 1;
  static const int entryCount = 2;

  static final RegExp _legalKeyPattern = RegExp('[a-z0-9_-]{1,120}');

  final RawCache _cache;
  final KeyExtractor _keyExtractor;
  int _networkCount = 0;
  int _hitCount = 0;
  int _requestCount = 0;

  int networkCount() {
    return _networkCount;
  }

  int hitCount() {
    return _hitCount;
  }

  int requestCount() {
    return _requestCount;
  }

  String _key(Uri url) {
    var key = _keyExtractor(url);
    if (key == null || key.isEmpty) {
      throw AssertionError('key is null or empty');
    }
    if (_legalKeyPattern.stringMatch(key) != key) {
      throw AssertionError('keys must match regex [a-z0-9_-]{1,120}: \"$key\"');
    }
    return key;
  }

  Future<void> trackConditionalCacheHit() async {
    _networkCount++;
  }

  Future<void> trackResponse(CacheStrategy cacheStrategy) async {
    _requestCount++;

    if (cacheStrategy.networkRequest != null) {
      // If this is a conditional request, we'll increment hitCount if/when it hits.
      _networkCount++;
    } else if (cacheStrategy.cacheResponse != null) {
      // This response uses the cache and not the network. That's a cache hit.
      _hitCount++;
    }
  }

  Future<Response> get(Request request) async {
    var key = _key(request.url);
    Snapshot snapshot;
    Entry entry;
    try {
      snapshot = await _cache.get(key);
      if (snapshot == null) {
        return null;
      }
    } catch (e) {
      // Give up because the cache cannot be read.
      return null;
    }

    try {
      entry = await Entry.sourceEntry(snapshot.getSource(entryMetaData));
    } catch (e) {
      return null;
    }

    Response response = entry.response(snapshot);

    if (!entry.matches(request, response)) {
      return null;
    }

    return response;
  }

  Future<CacheRequest> put(Response response) async {
    String requestMethod = response.request().method();
    if (HttpMethod.invalidatesCache(requestMethod)) {
      try {
        await remove(response.request());
      } catch (e) {
        // The cache cannot be written.
      }
      return null;
    }
    if (requestMethod != HttpMethod.get) {
      // Don't cache non-GET responses. We're technically allowed to cache
      // HEAD requests and some POST requests, but the complexity of doing
      // so is high and the benefit is low.
      return null;
    }

    if (HttpHeadersExtension.hasVaryAll(response.headers())) {
      return null;
    }

    var entry = Entry.responseEntry(response);
    Editor editor;
    try {
      editor = await _cache.edit(_key(response.request().uri()));
      if (editor == null) {
        return null;
      }
      var metaData = entry.metaData();
      return CacheRequest(editor, metaData);
    } catch (e) {
      await _abortQuietly(editor);
      return null;
    }
  }

  Future<void> update(Response cached, Response network) async {
    Entry entry = Entry.responseEntry(network);
    _CacheResponseBody body = cached.body() as _CacheResponseBody;
    Snapshot snapshot = body.snapshot();
    Editor editor;
    try {
      editor = await _cache.edit(snapshot.key(), snapshot.sequenceNumber());
      if (editor != null) {
        List<int> metaData = entry.metaData();
        EventSink<List<int>> sink = editor.newSink(Cache.entryMetaData, utf8);
        sink.add(metaData);
        editor.commit();
      }
    } catch (e) {
      await _abortQuietly(editor);
    }
  }

  Future<bool> remove(Request request) {
    return _cache.remove(_key(request.url()));
  }

  Future<void> _abortQuietly(Editor editor) async {
    // Give up because the cache cannot be written.
    try {
      if (editor != null) {
        editor.abort();
      }
    } catch (e) {
      // do nothing
    }
  }
}

class CacheRequest {
  CacheRequest(this.editor, this.metaData);

  final Editor editor;
  final List<int> metaData;

  EventSink<List<int>> body() {
    EventSink<List<int>> bodySink;
    StreamController<List<int>> streamController =
    StreamController<List<int>>();
    streamController.stream.listen(
          (List<int> event) {
        // add
        if (bodySink == null) {
          bodySink = editor.newSink(Cache.entryBody, utf8);
        }
        bodySink.add(event);
      },
      onError: (Object error, StackTrace stackTrace) {
        // detch
        bodySink?.addError(error, stackTrace);
        editor.abort();
      },
      onDone: () {
        // close
        EventSink<List<int>> metaDataSink =
        editor.newSink(Cache.entryMetaData, utf8);
        metaDataSink.add(metaData);
        editor.commit();
      },
      cancelOnError: true,
    );
    return streamController;
  }
}

abstract class Editor {
  StreamSink<List<int>> newSink(int index, Encoding encoding);

  Stream<List<int>> newSource(int index, Encoding encoding);

  void commit();

  void abort();
}

abstract class RawCache {
  static const int anySequenceNumber = -1;

  Future<Snapshot> get(String key);

  Future<Editor> edit(String key, [int expectedSequenceNumber]);

  Future<bool> remove(String key);
}

typedef String KeyExtractor(Uri url);

String _defaultKeyExtractor(Uri url) =>
    hex.encode(md5
        .convert(utf8.encode(url.toString()))
        .bytes);

class Snapshot {
  Snapshot(String key,
      int sequenceNumber,
      List<Stream<List<int>>> sources,
      List<int> lengths,)
      : _key = key,
        _sequenceNumber = sequenceNumber,
        _sources = sources,
        _lengths = lengths;

  final String _key;
  final int _sequenceNumber;
  final List<Stream<List<int>>> _sources;
  final List<int> _lengths;

  String key() {
    return _key;
  }

  int sequenceNumber() {
    return _sequenceNumber;
  }

  Stream<List<int>> getSource(int index) {
    return _sources[index];
  }

  int getLength(int index) {
    return _lengths[index];
  }
}

/// Reads an entry from an input stream. A typical entry looks like this:
///
/// ```
/// http://google.com/foo
/// GET
/// 2
/// Accept-Language: fr-CA
/// Accept-Charset: UTF-8
/// HTTP/1.1 200 OK
/// 3
/// Content-Type: image/png
/// Content-Length: 100
/// Cache-Control: max-age=600
/// ```
///
/// A typical HTTPS file looks like this:
///
/// ```
/// https://google.com/foo
/// GET
/// 2
/// Accept-Language: fr-CA
/// Accept-Charset: UTF-8
/// HTTP/1.1 200 OK
/// 3
/// Content-Type: image/png
/// Content-Length: 100
/// Cache-Control: max-age=600
///
/// AES_256_WITH_MD5
/// 2
/// base64-encoded peerCertificate[0]
/// base64-encoded peerCertificate[1]
/// -1
/// TLSv1.2
/// ```
///
/// The file is newline separated. The first two lines are the URL and the request method. Next
/// is the number of HTTP Vary request header lines, followed by those lines.
///
/// Next is the response status line, followed by the number of HTTP response header lines,
/// followed by those lines.
///
/// HTTPS responses also contain SSL session information. This begins with a blank line, and then
/// a line containing the cipher suite. Next is the length of the peer certificate chain. These
/// certificates are base64-encoded and appear each on their own line. The next line contains the
/// length of the local certificate chain. These certificates are also base64-encoded and appear
/// each on their own line. A length of -1 is used to encode a null array. The last line is
/// optional. If present, it contains the TLS version.
class _Entry {
  _Entry(this._url,
      this._requestMethod,
      this._varyHeaders,
      this._code,
      this._message,
      this._responseHeaders,
      this._sentRequestMillis,
      this._receivedResponseMillis,);

  static const String _sentMillis = 'OkHttp-Sent-Millis';
  static const String _receivedMillis = 'OkHttp-Received-Millis';

  final String _url;
  final String _requestMethod;
  final Headers _varyHeaders;
  final int _code;
  final String _message;
  final Headers _responseHeaders;
  final int _sentRequestMillis;
  final int _receivedResponseMillis;
  Handshake handshake;

  factory _Entry.fromResponse(Response response) {
    return _Entry(
        response.request.url.toString()
        ,
        response.varyHeaders
        ,
        response.request.method
        ,
        response.protocol
        ,
        response.code
        ,
        response.message
        ,
        response.headers
        ,
        response.handshake
        ,
        response.sentRequestAtMillis
        ,
        response.receivedResponseAtMillis
    )
  }

  List<int> metaData() {
    var builder = StringBuffer();
    builder.writeln(_url);
    builder.writeln(_requestMethod);
    builder.writeln(_varyHeaders.length.toString());
    for (var i = 0, size = _varyHeaders.length; i < size; i++) {
      _varyHeaders[''];
      builder.writeln('${_varyHeaders[i]}: ${_varyHeaders.valueAt(i)}');
    }
    builder.writeln('$_code $_message');
    Headers responseHeaders = _responseHeaders
        .newBuilder()
        .set(_sentMillis, _sentRequestMillis.toString())
        .set(_receivedMillis, _receivedResponseMillis.toString())
        .build();
    builder.writeln(responseHeaders.size().toString());
    for (int i = 0, size = responseHeaders.size(); i < size; i++) {
      builder.writeln(
          '${responseHeaders.nameAt(i)}: ${responseHeaders.valueAt(i)}');
    }
    return utf8.encode(builder.toString());
  }

  Response response(Snapshot snapshot) {
    String contentTypeString =
    _responseHeaders.value(HttpHeaders.contentTypeHeader);
    MediaType contentType =
    contentTypeString != null ? MediaType.parse(contentTypeString) : null;
    String contentLengthString =
    _responseHeaders.value(HttpHeaders.contentLengthHeader);
    int contentLength = contentLengthString != null
        ? (int.tryParse(contentLengthString) ?? -1)
        : -1;
    Request cacheRequest = RequestBuilder()
        .uri(HttpUrl.parse(_url))
        .method(_requestMethod, null)
        .headers(_varyHeaders)
        .build();
    return ResponseBuilder()
        .request(cacheRequest)
        .code(_code)
        .message(_message)
        .headers(_responseHeaders)
        .body(_CacheResponseBody(contentType, contentLength, snapshot))
        .sentRequestAtMillis(_sentRequestMillis)
        .receivedResponseAtMillis(_receivedResponseMillis)
        .build();
  }

  bool matches(Request request, Response response) {
    return _url == request.url().toString() &&
        _requestMethod == request.method() &&
        HttpHeadersExtension.varyMatches(response, _varyHeaders, request);
  }

  static Future<Entry> sourceEntry(Stream<List<int>> source) async {
    List<String> lines = await Util.readAsBytes(source).then((List<int> bytes) {
      return utf8.decode(bytes);
    }).then(const LineSplitter().convert);

    int cursor = 0;
    String url = lines[cursor++];
    String requestMethod = lines[cursor++];
    HeadersBuilder varyHeadersBuilder = HeadersBuilder();
    int varyRequestHeaderLineCount = int.tryParse(lines[cursor++]);
    for (int i = 0; i < varyRequestHeaderLineCount; i++) {
      varyHeadersBuilder.addLenientLine(lines[cursor++]);
    }
    Headers varyHeaders = varyHeadersBuilder.build();

    String statusLine = lines[cursor++];
    if (statusLine == null || statusLine.length < 3) {
      throw Exception('Unexpected status line: $statusLine');
    }
    int code = int.tryParse(statusLine.substring(0, 3));
    String message = statusLine.substring(3).replaceFirst(' ', '');

    HeadersBuilder responseHeadersBuilder = HeadersBuilder();
    int responseHeaderLineCount = int.tryParse(lines[cursor++]);
    for (int i = 0; i < responseHeaderLineCount; i++) {
      responseHeadersBuilder.addLenientLine(lines[cursor++]);
    }
    Headers responseHeaders = responseHeadersBuilder.build();

    String sendRequestMillisString = responseHeaders.value(_sentMillis);
    String receivedResponseMillisString =
    responseHeaders.value(_receivedMillis);

    responseHeaders = responseHeaders
        .newBuilder()
        .removeAll(_sentMillis)
        .removeAll(_receivedMillis)
        .build();

    int sentRequestMillis = int.tryParse(sendRequestMillisString);
    int receivedResponseMillis = int.tryParse(receivedResponseMillisString);

    return Entry(
        url,
        requestMethod,
        varyHeaders,
        code,
        message,
        responseHeaders,
        sentRequestMillis,
        receivedResponseMillis);
  }

  static Entry responseEntry(Response response) {
    String url = response.request().uri().toString();
    Headers varyHeaders = HttpHeadersExtension.varyHeaders(response);
    String requestMethod = response.request().method();
    int code = response.code();
    String message = response.message();
    Headers responseHeaders = response.headers();
    int sentRequestMillis = response.sentRequestAtMillis();
    int receivedResponseMillis = response.receivedResponseAtMillis();
    return Entry(
        url,
        requestMethod,
        varyHeaders,
        code,
        message,
        responseHeaders,
        sentRequestMillis,
        receivedResponseMillis);
  }
}

class _CacheResponseBody extends ResponseBody {
  _CacheResponseBody(MediaType contentType,
      int contentLength,
      Snapshot snapshot,)
      : _contentType = contentType,
        _contentLength = contentLength,
        _snapshot = snapshot;

  final MediaType _contentType;
  final int _contentLength;
  final Snapshot _snapshot;

  @override
  MediaType contentType() {
    return _contentType;
  }

  @override
  int contentLength() {
    return _contentLength;
  }

  Snapshot snapshot() {
    return _snapshot;
  }

  @override
  Stream<List<int>> source() {
    return _snapshot.getSource(Cache.entryBody);
  }
}
