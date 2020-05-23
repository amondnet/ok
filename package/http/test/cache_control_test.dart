import 'dart:io';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ok_http/src/cache_control.dart';
import 'package:test/test.dart';
import 'package:ok_http/ok_http.dart';

void main() {
  group('CacheControl', () {
    test('emptyBuilderIsEmpty', () {
      var cacheControl = CacheControlBuilder().build();
      expect(cacheControl.toString(), '');
      expect(cacheControl.noCache, isFalse);
      expect(cacheControl.noStore, isFalse);
      expect(cacheControl.maxAgeSeconds, -1);
      expect(cacheControl.sMaxAgeSeconds, -1);
      expect(cacheControl.isPrivate, isFalse);
      expect(cacheControl.isPublic, isFalse);
      expect(cacheControl.mustRevalidate, isFalse);
      expect(cacheControl.maxStaleSeconds, -1);
      expect(cacheControl.minFreshSeconds, -1);
      expect(cacheControl.onlyIfCached, isFalse);
      expect(cacheControl.mustRevalidate, isFalse);
    });

    test('completeBuilder', () {
      var cacheControl = CacheControlBuilder()
          .noCache()
          .noStore()
          .maxAge(Duration(seconds: 1))
          .maxStale(Duration(seconds: 2))
          .minFresh(Duration(seconds: 3))
          .onlyIfCached()
          .noTransform()
          .immutable()
          .build();
      expect(
          cacheControl.toString(),
          'no-cache, no-store, max-age=1, max-stale=2, min-fresh=3, only-if-cached, '
          'no-transform, immutable');
      expect(cacheControl.noCache, isTrue);
      expect(cacheControl.noStore, isTrue);
      expect(cacheControl.maxAgeSeconds, equals(1));
      expect(cacheControl.maxStaleSeconds, equals(2));
      expect(cacheControl.minFreshSeconds, equals(3));
      expect(cacheControl.onlyIfCached, isTrue);
      expect(cacheControl.noTransform, isTrue);
      expect(cacheControl.immutable, isTrue);

      // These members are accessible to response headers only.
      expect(cacheControl.sMaxAgeSeconds, equals(-1));
      expect(cacheControl.isPrivate, isFalse);
      expect(cacheControl.isPublic, isFalse);
      expect(cacheControl.mustRevalidate, isFalse);
    });
  });
}
