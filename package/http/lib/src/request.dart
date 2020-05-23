import 'dart:io';

import 'package:http/http.dart';
import 'package:ok_http/src/request_body.dart';
import 'package:quiver/collection.dart';
import 'internal/http_method.dart';

class RequestBuilder {
  Uri _url;
  String _method;
  Multimap<String, String> _headers;
  RequestBody _body;

  RequestBuilder()
      : _method = HttpMethod.get,
        _headers = Multimap();

  RequestBuilder url(Uri value) {
    _url = value;
    return this;
  }

  RequestBuilder header(String name, String value) {
    _headers.removeAll(name);
    _headers.add(name, value);
    return this;
  }

  RequestBuilder addHeader(String name, String value) {
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
    String value = cacheControl?.toString() ?? '';
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
