# okhttp

[![pub package](https://badgen.net/pub/v/ok_http)](https://pub.dartlang.org/packages/ok_http)
![coverage](./coverage_badge.svg)
[![pub license](https://badgen.net/pub/license/ok_http)](https://pub.dartlang.org/packages/ok_http)
[![sdk-version](https://badgen.net/pub/sdk-version/ok_http)](https://pub.dartlang.org/packages/ok_http)

A package:http BaseClient that speaks HTTP/2, and can maintain connections between requests.

This can be dropped into any API that uses a BaseClient, so you can seamlessly start working with HTTP/2 right away.

It also can fallback to HTTP/1.1 automatically.

## Installation



## Usage

A simple usage example:

```dart
import 'package:ok/ok.dart';

main() {
  var awesome = new Awesome();
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
