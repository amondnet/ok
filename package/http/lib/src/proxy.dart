import 'dart:async';

typedef Proxy = String Function(Uri url);

abstract class ProxySelector {
  FutureOr<Proxy> select();
}
