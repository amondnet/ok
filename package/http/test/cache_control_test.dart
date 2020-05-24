import 'dart:collection';

import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:okhttp/src/cache_control.dart';
import 'package:okhttp/src/headers.dart';
import 'package:test/test.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
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

    test('parseEmpty', () {
      var cacheControl =
          CacheControl.parse(HeadersBuilder().set('Cache-Control', '').build());

      expect(cacheControl.toString(), equals(''));
      expect(cacheControl.noCache, isFalse);
      expect(cacheControl.noStore, isFalse);
      expect(cacheControl.maxAgeSeconds, equals(-1));
      expect(cacheControl.sMaxAgeSeconds, equals(-1));
      expect(cacheControl.isPublic, isFalse);
      expect(cacheControl.mustRevalidate, isFalse);
      expect(cacheControl.maxStaleSeconds, equals(-1));
      expect(cacheControl.minFreshSeconds, equals(-1));
      expect(cacheControl.onlyIfCached, isFalse);
      expect(cacheControl.mustRevalidate, isFalse);
    });

    test('parse', () {
      var header =
          'no-cache, no-store, max-age=1, s-maxage=2, private, public, must-revalidate, '
          'max-stale=3, min-fresh=4, only-if-cached, no-transform';

      var cacheControl = CacheControl.parse(
          HeadersBuilder().set('Cache-Control', header).build());

      expect(cacheControl.noCache, isTrue);
      expect(cacheControl.noStore, isTrue);
      expect(cacheControl.maxAgeSeconds, 1);
      expect(cacheControl.sMaxAgeSeconds, 2);
      expect(cacheControl.isPrivate, isTrue);
      expect(cacheControl.isPublic, isTrue);
      expect(cacheControl.mustRevalidate, isTrue);
      expect(cacheControl.maxStaleSeconds, 3);
      expect(cacheControl.minFreshSeconds, 4);
      expect(cacheControl.onlyIfCached, isTrue);
      expect(cacheControl.noTransform, isTrue);
      expect(cacheControl.toString(), header);
    });

    test('parseIgnoreCacheControlExtensions', () {
      // Example from http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9.6
      var header = 'private, community=\"UCI\"';

      var cacheControl = CacheControl.parse(
          HeadersBuilder().set('Cache-Control', header).build());

      expect(cacheControl.noCache, isFalse);
      expect(cacheControl.noStore, isFalse);
      expect(cacheControl.maxAgeSeconds, -1);
      expect(cacheControl.sMaxAgeSeconds, -1);
      expect(cacheControl.isPrivate, isTrue);
      expect(cacheControl.isPublic, isFalse);
      expect(cacheControl.mustRevalidate, isFalse);
      expect(cacheControl.maxStaleSeconds, -1);
      expect(cacheControl.minFreshSeconds, -1);
      expect(cacheControl.onlyIfCached, isFalse);
      expect(cacheControl.noTransform, isFalse);
      expect(cacheControl.toString(), header);
    });

    test('parseCacheControlAndPragmaAreCombined', () {
      var headers = Headers.fromEntries({
        MapEntry('Cache-Control', 'max-age=12'),
        MapEntry('Pragma', 'must-revalidate'),
        MapEntry('Pragma', 'public')
      });
      var cacheControl = CacheControl.parse(headers);
      expect(cacheControl.toString(), 'max-age=12, public, must-revalidate');
    });

    test('parseCacheControlHeaderValueIsRetained', () {
      var value = 'max-age=12';
      var headers = Headers.of([
        'Cache-Control',
        'max-age=12',
      ]);
      var cacheControl = CacheControl.parse(headers);
      expect(cacheControl.toString(), value);
    });

    test('parseCacheControlHeaderValueInvalidatedByPragma', () {
      var headers = Headers.of(
          ['Cache-Control', 'max-age=12', 'Pragma', 'must-revalidate']);
      var cacheControl = CacheControl.parse(headers);
      expect(cacheControl.toString(), 'max-age=12, must-revalidate');
    });

    test('parseCacheControlHeaderValueInvalidatedByTwoValues', () {
      var headers = Headers.of(
          ['Cache-Control', 'max-age=12', 'Cache-Control', 'must-revalidate']);
      var cacheControl = CacheControl.parse(headers);
      expect(cacheControl.toString(), 'max-age=12, must-revalidate');
    });

    test('parsePragmaHeaderValueIsNotRetained', () {
      var headers = Headers.of(['Pragma', 'must-revalidate']);

      var cacheControl = CacheControl.parse(headers);
      expect(cacheControl.toString(), 'must-revalidate');
    });

    test('computedHeaderValueIsCached', () {
      var cacheControl =
          CacheControlBuilder().maxAge(Duration(days: 2)).build();
      expect(cacheControl.toString(), 'max-age=172800');
      expect(cacheControl.toString(), cacheControl.toString());
    });

    test('timeDurationTruncatedToMaxValue', () {
      var cacheControl = CacheControlBuilder()
          .maxAge(Duration(
              days: 365 * 100)) // Longer than Integer.MAX_VALUE seconds.
          .build();
      expect(cacheControl.maxAgeSeconds, Int32.MAX_VALUE);
    });

    test('secondsMustBeNonNegative', () {
      var builder = CacheControlBuilder();

      expect(() => builder.maxAge(Duration(seconds: -1)), throwsArgumentError);
    });

    test('timePrecisionIsTruncatedToSeconds', () {
      var cacheControl =
          CacheControlBuilder().maxAge(Duration(milliseconds: 4999)).build();

      expect(cacheControl.maxAgeSeconds, 4);
    });
  });
}
