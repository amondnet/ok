import 'dart:io';

abstract class CookieJar {
  static const CookieJar noCookies = _NoCookieJar();

  Future<void> saveFromResponse(Uri url, List<Cookie> cookies);

  Future<List<Cookie>> loadForRequest(Uri url);
}

class _NoCookieJar implements CookieJar {
  const _NoCookieJar();

  @override
  Future<void> saveFromResponse(Uri url, List<Cookie> cookies) async {}

  @override
  Future<List<Cookie>> loadForRequest(Uri url) async {
    return List<Cookie>.unmodifiable(<Cookie>[]);
  }
}
