import 'dart:async';

import 'interceptor.dart';
import 'internal/cache/cache_interceptor.dart';
import 'internal/http/call_server_interceptor.dart';
import 'ok_http_client.dart';
import 'request.dart';
import 'response.dart';

abstract class Call {
  Future<Response> enqueue();

  void cancel(Object error, [StackTrace stackTrace]);
}

class RealCall implements Call {
  RealCall.newRealCall(OkHttpClient client, Request originalRequest)
      : _client = client,
        _originalRequest = originalRequest;

  final OkHttpClient _client;
  final Request _originalRequest;
  final Completer<Response> _completer = Completer<Response>();

  @override
  Future<Response> enqueue() {
    var interceptors = <Interceptor>[];
    interceptors.addAll(_client.interceptors);
    interceptors.add(BridgeInterceptor(_client.cookieJar));
    interceptors.add(CacheInterceptor(_client.cache));
    interceptors.addAll(_client.networkInterceptors);
    interceptors.add(CallServerInterceptor(_client));
    Chain chain = RealInterceptorChain(interceptors, 0, _originalRequest);
    _completer.complete(chain.proceed(_originalRequest));
    return _completer.future;
  }

  @override
  void cancel(Object error, [StackTrace stackTrace]) {
    _completer.completeError(error, stackTrace);
  }
}
