// https://github.com/thosakwe/http2_client/issues/1#issuecomment-455759645

import 'dart:async';
import 'dart:io';

import 'package:ok_http2/ok_http2.dart';

Future<void> main() async {
  var client = Http2Client(maxOpenConnections: Platform.numberOfProcessors);
  await doRequest(client);
  var sleepTime = const Duration(seconds: 30);
  print('Sleeping for ${sleepTime.inSeconds} second(s)');
  await Future.delayed(sleepTime);
  await doRequest(client);
}

Future<void> doRequest(Http2Client client) async {
  print('Sending request');
  var response = await client.get('https://www.cloudflare.com/');
  print('Got response status ${response.statusCode}');
  print('Read ${response.body.length} bytes from www.cloudflare.com');
}
