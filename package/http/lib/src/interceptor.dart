import 'call.dart';
import 'request.dart';
import 'response.dart';

abstract class Interceptor {
  Future<Response> intercept(Chain change);
}

abstract class Chain {
  Request request();

  Future<Response> proceed(Request request);

  /**
   * Returns the connection the request will be executed on. This is only available in the chains
   * of network interceptors; for application interceptors this is always null.
   */
  Connection connection();

  Call call();

  int connectTimeoutMillis();

  Chain withConnectTimeout(Duration timeout);

  int readTimeoutMillis();

  Chain withReadTimeout(Duration timeout);

  int writeTimeoutMillis();

  Chain withWriteTimeout(Duration timeout);
}

class Connection {}
