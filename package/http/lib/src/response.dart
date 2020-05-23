import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:quiver/check.dart';
import 'package:http/http.dart' as http;
import 'package:ok_http/src/internal/buffer.dart';
import 'package:ok_http/src/protocol.dart';

import 'cache_control.dart';
import 'headers.dart';
import 'request.dart';
import 'response_body.dart';

class Response {
  Response._(
    ResponseBuilder builder,
  )   : _request = builder._request,
        _code = builder._code,
        _message = builder._message,
        _headers = builder._headers.build(),
        _body = builder._body,
        _networkResponse = builder._networkResponse,
        _cacheResponse = builder._cacheResponse,
        _priorResponse = builder._priorResponse,
        _sentRequestAtMillis = builder._sentRequestAtMillis,
        _receivedResponseAtMillis = builder._receivedResponseAtMillis;

  final Request _request;
  final int _code;
  final String _message;
  final Headers _headers;
  final ResponseBody _body;
  final Response _networkResponse;
  final Response _cacheResponse;
  final Response _priorResponse;
  final int _sentRequestAtMillis;
  final int _receivedResponseAtMillis;

  CacheControl _cacheControl;

  Request get request {
    return _request;
  }

  int get code {
    return _code;
  }

  bool get isSuccessful {
    return _code >= HttpStatus.ok && _code < HttpStatus.multipleChoices;
  }

  String get message {
    return _message;
  }

  String header(String name) {
    return _headers[name].first;
  }

  Headers get headers => _headers;

  List<String> headersByName(String name) {
    return _headers[name];
  }

  ResponseBody get body {
    return _body;
  }

  Response get networkResponse {
    return _networkResponse;
  }

  Response get cacheResponse {
    return _cacheResponse;
  }

  Response get priorResponse {
    return _priorResponse;
  }

  CacheControl get cacheControl {
    _cacheControl ??= CacheControl.parse(_headers);
    return _cacheControl;
  }

  int get sentRequestAtMillis {
    return _sentRequestAtMillis;
  }

  int get receivedResponseAtMillis {
    return _receivedResponseAtMillis;
  }

  ResponseBuilder newBuilder() {
    return ResponseBuilder._(this);
  }

  static ResponseBuilder builder() {
    return ResponseBuilder();
  }

  Future<ResponseBody> peekBody(int byteCount) async {
    final peeked = await body.source.first;
    final buffer = BytesBuffer();
    buffer.add(peeked.sublist(0, min(byteCount, peeked.length)));

    return ResponseBody.bytesBody(body.contentType, buffer.toBytes());
  }
}

class ResponseBuilder {
  ResponseBuilder() : _headers = HeadersBuilder();

  ResponseBuilder._(
    Response response,
  )   : _request = response._request,
        _code = response._code,
        _message = response._message,
        _headers = response._headers.newBuilder(),
        _body = response._body,
        _networkResponse = response._networkResponse,
        _cacheResponse = response._cacheResponse,
        _priorResponse = response._priorResponse,
        _sentRequestAtMillis = response._sentRequestAtMillis,
        _receivedResponseAtMillis = response._receivedResponseAtMillis;

  Request _request;
  Protocol _protocol;
  int _code = -1;
  String _message;
  HeadersBuilder _headers;
  ResponseBody _body;
  Response _networkResponse;
  Response _cacheResponse;
  Response _priorResponse;
  int _sentRequestAtMillis = 0;
  int _receivedResponseAtMillis = 0;

  ResponseBuilder request(Request value) {
    _request = value;
    return this;
  }

  ResponseBuilder code(int value) {
    _code = value;
    return this;
  }

  ResponseBuilder message(String value) {
    _message = value;
    return this;
  }

  ResponseBuilder header(String name, String value) {
    _headers.set(name, value);
    return this;
  }

  ResponseBuilder addHeader(String name, String value) {
    _headers.add(name, value);
    return this;
  }

  ResponseBuilder removeHeader(String name) {
    _headers.removeAll(name);
    return this;
  }

  ResponseBuilder headers(Headers value) {
    _headers = value.newBuilder();
    return this;
  }

  ResponseBuilder body(ResponseBody value) {
    _body = value;
    return this;
  }

  ResponseBuilder networkResponse(Response value) {
    _networkResponse = value;
    return this;
  }

  ResponseBuilder cacheResponse(Response value) {
    _cacheResponse = value;
    return this;
  }

  ResponseBuilder priorResponse(Response value) {
    _priorResponse = value;
    return this;
  }

  ResponseBuilder sentRequestAtMillis(int value) {
    _sentRequestAtMillis = value;
    return this;
  }

  ResponseBuilder receivedResponseAtMillis(int value) {
    _receivedResponseAtMillis = value;
    return this;
  }

  Response build() {
    checkState(_code >= 0, message: 'code < 0: $_code');
    checkNotNull(_request, message: 'request == null');
    checkNotNull(_protocol, message: 'protocol == null');
    checkNotNull(_message, message: 'message == null');

    assert(_message != null);
    return Response._(this);
  }

  ResponseBuilder protocol(Protocol protocol) {
    _protocol = protocol;
    return this;
  }
}
