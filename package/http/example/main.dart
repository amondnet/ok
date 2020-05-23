import 'dart:io';

import 'package:logging/logging.dart';
import 'package:ok_http/ok_http.dart';

void main() async {
  var client = Http2Client(maxOpenConnections: 1);
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  var response = await client.get('https://api.clayful.io/v1/',
      headers: {'Content-Type': 'application/json'});
  print(response.body);
  client.close();
}
