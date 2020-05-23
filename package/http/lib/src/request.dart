import 'dart:io';

import 'package:ok_http/src/request_body.dart';
import 'package:quiver/check.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/strings.dart';
import 'cache_control.dart';
import 'headers.dart';
import 'internal/http_method.dart';

class Request {
  Request._(
    RequestBuilder builder,
  )   : _url = builder._url,
        _method = builder._method,
        _headers = builder._headers,
        _body = builder._body;

  final Uri _url;
  final String _method;
  final Headers _headers;
  final RequestBody _body;

  CacheControl _cacheControl;

  Uri get url {
    return _url;
  }

  String get method {
    return _method;
  }

  String header(String name) {
    return _headers[name.toLowerCase()].first;
  }

  Headers get headers => _headers;

  List<String> headersByName(String name) {
    return _headers[name.toLowerCase()].toList();
  }

  /// Returns the cache control directives for this response. This is never null, even if this
  /// response contains no `Cache-Control` header.
  CacheControl get cacheControl =>
      _cacheControl ??= CacheControl.parse(_headers);

  RequestBody get body {
    return _body;
  }

  RequestBuilder newBuilder() {
    return RequestBuilder._(this);
  }

  static RequestBuilder builder() {
    return RequestBuilder();
  }
}

class RequestBuilder {
  Uri _url;
  String _method = HttpMethod.get;
  Headers _headers;
  RequestBody _body;

  RequestBuilder()
      : _method = HttpMethod.get,
        _headers = Headers.fromMap({});

  RequestBuilder._(
    Request request,
  )   : _url = request._url,
        _method = request._method,
        _headers = request._headers,
        _body = request._body;

  RequestBuilder uri(Uri value) {
    _url = value;
    return this;
  }

  RequestBuilder url(String url) {
    checkNotNull(url);
    checkArgument(isNotBlank(url));

    _url = Uri.parse(url);
    return this;
  }

  RequestBuilder header(String name, String value) {
    checkNotNull(name);
    checkArgument(isNotBlank(name));
    _headers.removeAll(name);
    _headers.add(name, value);
    return this;
  }

  RequestBuilder addHeader(String name, String value) {
    checkNotNull(name);
    checkNotNull(value);

    checkArgument(isNotBlank(name));
    checkArgument(isNotBlank(value));

    _headers.add(name, value);
    return this;
  }

  RequestBuilder removeHeader(String name) {
    _headers.removeAll(name);
    return this;
  }

  RequestBuilder headers(Multimap<String, String> headers) {
    _headers = headers;
    return this;
  }

  RequestBuilder cacheControl(CacheControl cacheControl) {
    var value = cacheControl?.toString() ?? '';
    if (value.isEmpty) {
      return removeHeader(HttpHeaders.cacheControlHeader);
    }
    return header(HttpHeaders.cacheControlHeader, value);
  }

  RequestBuilder get() {
    return method(HttpMethod.get, null);
  }

  RequestBuilder head() {
    return method(HttpMethod.head, null);
  }

  RequestBuilder post(RequestBody body) {
    return method(HttpMethod.post, body);
  }

  RequestBuilder delete(RequestBody body) {
    return method(HttpMethod.delete, body);
  }

  RequestBuilder put(RequestBody body) {
    return method(HttpMethod.put, body);
  }

  RequestBuilder patch(RequestBody body) {
    return method(HttpMethod.patch, body);
  }

  RequestBuilder method(String method, RequestBody body) {
    assert(method != null && method.isNotEmpty);
    if (body != null && !HttpMethod.permitsRequestBody(method)) {
      throw AssertionError('method $method must not have a request body.');
    }
    if (body == null && HttpMethod.requiresRequestBody(method)) {
      throw AssertionError('method $method must have a request body.');
    }
    _method = method;
    _body = body;
    return this;
  }

  Request build() {
    assert(_url != null);
    return Request._(this);
  }
}
