import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:quiver/collection.dart';

class CacheControl {
  CacheControl._(
      this._noCache,
      this._noStore,
      this._maxAgeSeconds,
      this._sMaxAgeSeconds,
      this._isPrivate,
      this._isPublic,
      this._mustRevalidate,
      this._maxStaleSeconds,
      this._minFreshSeconds,
      this._onlyIfCached,
      this._noTransform,
      this._immutable,
      this._headerValue);

  CacheControl._fromBuilder(
    CacheControlBuilder builder,
  )   : _noCache = builder._noCache,
        _noStore = builder._noStore,
        _maxAgeSeconds = builder._maxAgeSeconds,
        _sMaxAgeSeconds = -1,
        _isPrivate = false,
        _isPublic = false,
        _mustRevalidate = false,
        _maxStaleSeconds = builder._maxStaleSeconds,
        _minFreshSeconds = builder._minFreshSeconds,
        _onlyIfCached = builder._onlyIfCached,
        _noTransform = builder._noTransform,
        _immutable = builder._immutable;

  static final CacheControl forceNetwork =
      CacheControlBuilder().noCache().build();

  static final CacheControl forceCache = CacheControlBuilder()
      .onlyIfCached()
      .maxStale(Duration(seconds: Int32.MAX_VALUE.toInt()))
      .build();

  static const String _params_no_cache = 'no-cache';
  static const String _params_no_store = 'no-store';
  static const String _params_max_age = 'max-age';
  static const String _params_s_maxage = 's-maxage';
  static const String _params_private = 'private';
  static const String _params_public = 'public';
  static const String _params_must_revalidate = 'must-revalidate';
  static const String _params_max_stale = 'max-stale';
  static const String _params_min_fresh = 'min-fresh';
  static const String _params_only_if_cached = 'only-if-cached';
  static const String _params_no_transform = 'no-transform';
  static const String _params_immutable = 'immutable';

  final bool _noCache;
  final bool _noStore;
  final int _maxAgeSeconds;
  final int _sMaxAgeSeconds;
  final bool _isPrivate;
  final bool _isPublic;
  final bool _mustRevalidate;
  final int _maxStaleSeconds;
  final int _minFreshSeconds;
  final bool _onlyIfCached;
  final bool _noTransform;
  final bool _immutable;
  String _headerValue;

  bool get noCache {
    return _noCache;
  }

  bool get noStore {
    return _noStore;
  }

  int get maxAgeSeconds {
    return _maxAgeSeconds;
  }

  int get sMaxAgeSeconds {
    return _sMaxAgeSeconds;
  }

  bool get isPrivate {
    return _isPrivate;
  }

  bool get isPublic {
    return _isPublic;
  }

  bool get mustRevalidate {
    return _mustRevalidate;
  }

  int get maxStaleSeconds {
    return _maxStaleSeconds;
  }

  int get minFreshSeconds {
    return _minFreshSeconds;
  }

  bool get onlyIfCached {
    return _onlyIfCached;
  }

  bool get noTransform {
    return _noTransform;
  }

  bool get immutable {
    return _immutable;
  }

  @override
  String toString() {
    var result = _headerValue;
    if (result == null) {
      var result = StringBuffer();
      if (_noCache) {
        result.write('$_params_no_cache, ');
      }
      if (_noStore) {
        result.write('$_params_no_store, ');
      }
      if (_maxAgeSeconds >= 0) {
        result.write('$_params_max_age=$_maxAgeSeconds, ');
      }
      if (_sMaxAgeSeconds >= 0) {
        result.write('$_params_s_maxage=$_sMaxAgeSeconds, ');
      }
      if (_isPrivate) {
        result.write('$_params_private, ');
      }
      if (_isPublic) {
        result.write('$_params_public, ');
      }
      if (_mustRevalidate) {
        result.write('$_params_must_revalidate, ');
      }
      if (_maxStaleSeconds >= 0) {
        result.write('$_params_max_stale=$_maxStaleSeconds, ');
      }
      if (_minFreshSeconds >= 0) {
        result.write('$_params_min_fresh=$_minFreshSeconds, ');
      }
      if (_onlyIfCached) {
        result.write('$_params_only_if_cached, ');
      }
      if (_noTransform) {
        result.write('$_params_no_transform, ');
      }
      if (_immutable) {
        result.write('$_params_immutable, ');
      }
      if (result.isEmpty) return '';
      return result.toString().substring(0, result.length - 2);
    }
    return result;
  }

  static CacheControl parse(Multimap<String, String> headers) {
    var noCache = false;
    var noStore = false;
    var maxAgeSeconds = -1;
    var sMaxAgeSeconds = -1;
    var isPrivate = false;
    var isPublic = false;
    var mustRevalidate = false;
    var maxStaleSeconds = -1;
    var minFreshSeconds = -1;
    var onlyIfCached = false;
    var noTransform = false;
    var immutable = false;

    var canUseHeaderValue = true;
    String headerValue;

    var cacheControlHeaders = headers[HttpHeaders.cacheControlHeader];

    if (cacheControlHeaders.length > 1) {
      // Multiple cache-control headers means we can't use the raw value.
      canUseHeaderValue = cacheControlHeaders.length > 1;
    } else if (cacheControlHeaders.length == 1) {
      headerValue = cacheControlHeaders.first;
    }
    canUseHeaderValue = headers[HttpHeaders.pragmaHeader].isNotEmpty;

    var values = List.of(cacheControlHeaders);
    values.addAll(headers[HttpHeaders.pragmaHeader]);

    values.forEach((value) {
      var pos = 0;
      while (pos < value.length) {
        final tokenStart = pos;
        pos = value.indexOf(RegExp(r'[=,;]'), pos);
        var directive = value.substring(tokenStart, pos).trim();

        String parameter;
        if (pos == value.length || value[pos] == ',' || value[pos] == ';') {
          pos++; // consume ',' or ';' (if necessary)
          parameter = null;
        } else {
          pos++; // consume '='
          pos = value.indexOf(RegExp(r'[^\s]'), pos);

          // quoted string
          if (pos < value.length && value[pos] == '\"') {
            pos++; // consume '"' open quote
            var parameterStart = pos;
            pos = value.indexOf('\"', pos);
            parameter = value.substring(parameterStart, pos);
            pos++; // consume '"' close quote (if necessary)

            // unquoted string
          } else {
            var parameterStart = pos;
            pos = value.indexOf(RegExp(r'[,;]'), pos);
            parameter = value.substring(parameterStart, pos).trim();
          }
        }

        if (_params_no_cache == directive.toLowerCase()) {
          noCache = true;
        } else if (_params_no_store == directive.toLowerCase()) {
          noStore = true;
        } else if (_params_max_age == directive.toLowerCase()) {
          maxAgeSeconds = parameter != null ? int.tryParse(parameter) : -1;
        } else if (_params_s_maxage == directive.toLowerCase()) {
          sMaxAgeSeconds = parameter != null ? int.tryParse(parameter) : -1;
        } else if (_params_private == directive.toLowerCase()) {
          isPrivate = true;
        } else if (_params_public == directive.toLowerCase()) {
          isPublic = true;
        } else if (_params_must_revalidate == directive.toLowerCase()) {
          mustRevalidate = true;
        } else if (_params_max_stale == directive.toLowerCase()) {
          maxStaleSeconds = parameter != null
              ? int.tryParse(parameter)
              : Int32.MAX_VALUE.toInt();
        } else if (_params_min_fresh == directive.toLowerCase()) {
          minFreshSeconds = parameter != null ? int.tryParse(parameter) : -1;
        } else if (_params_only_if_cached == directive.toLowerCase()) {
          onlyIfCached = true;
        } else if (_params_no_transform == directive.toLowerCase()) {
          noTransform = true;
        } else if (_params_immutable == directive.toLowerCase()) {
          immutable = true;
        }
      }
    });
    if (!canUseHeaderValue) {
      headerValue = null;
    }
    return CacheControl._(
        noCache,
        noStore,
        maxAgeSeconds,
        sMaxAgeSeconds,
        isPrivate,
        isPublic,
        mustRevalidate,
        maxStaleSeconds,
        minFreshSeconds,
        onlyIfCached,
        noTransform,
        immutable,
        headerValue);
  }
}

class CacheControlBuilder {
  CacheControlBuilder();

  CacheControlBuilder._(
    CacheControl cacheControl,
  )   : _noCache = cacheControl._noCache,
        _noStore = cacheControl._noStore,
        _maxAgeSeconds = cacheControl._maxAgeSeconds,
        _maxStaleSeconds = cacheControl._maxStaleSeconds,
        _minFreshSeconds = cacheControl._minFreshSeconds,
        _onlyIfCached = cacheControl._onlyIfCached,
        _noTransform = cacheControl._noTransform,
        _immutable = cacheControl._immutable;

  bool _noCache = false;
  bool _noStore = false;
  int _maxAgeSeconds = -1;
  int _maxStaleSeconds = -1;
  int _minFreshSeconds = -1;
  bool _onlyIfCached = false;
  bool _noTransform = false;
  bool _immutable = false;

  CacheControlBuilder noCache() {
    _noCache = true;
    return this;
  }

  CacheControlBuilder noStore() {
    _noStore = true;
    return this;
  }

  CacheControlBuilder maxAge(Duration maxAge) {
    assert(maxAge != null);
    _maxAgeSeconds = maxAge.inSeconds;
    return this;
  }

  CacheControlBuilder maxStale(Duration maxStale) {
    assert(maxStale != null);
    _maxStaleSeconds = maxStale.inSeconds;
    return this;
  }

  CacheControlBuilder minFresh(Duration minFresh) {
    assert(minFresh != null);
    _minFreshSeconds = minFresh.inSeconds;
    return this;
  }

  CacheControlBuilder onlyIfCached() {
    _onlyIfCached = true;
    return this;
  }

  CacheControlBuilder noTransform() {
    _noTransform = true;
    return this;
  }

  CacheControlBuilder immutable() {
    _immutable = true;
    return this;
  }

  CacheControl build() {
    return CacheControl._fromBuilder(this);
  }
}
