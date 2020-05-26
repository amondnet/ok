import 'package:http/http.dart';

import 'closable.dart';

abstract class Transport implements Closable {
  BaseClient client;

  Future<Response> send(Request request);

  Future<void> cancel();
}
