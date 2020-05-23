import 'dart:collection';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:quiver/check.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/strings.dart';

class Headers implements Multimap<String, String> {
  Headers._(this._namesAndValues);

  final _namesAndValues;

  factory Headers.fromLinkedMap(LinkedHashMap<String, String> map) {
    var headers = ListMultimap<String, String>();

    map.forEach((key, value) {
      headers.add(key.toLowerCase(), value);
    });
    return Headers._(headers);
  }

  factory Headers.of(List<String> nameValues) {
    var headers = ListMultimap<String, String>();
    assert(nameValues.length.isEven);
    for (var i = 0; i < nameValues.length / 2; i++) {
      headers.add(nameValues[i * 2].toLowerCase(), nameValues[i * 2 + 1]);
    }
    return Headers._(headers);
  }

  factory Headers.fromMap(Map<String, String> map) {
    var headers = ListMultimap<String, String>();
    map.forEach((key, value) {
      headers.add(key.toLowerCase(), value);
    });
    return Headers._(headers);
  }

  factory Headers.fromIterables(
      Iterable<String> keys, Iterable<String> values) {
    assert(keys.length == values.length);
    var headers = ListMultimap<String, String>();
    var iterator = keys.iterator;
    var valueIterator = values.iterator;
    while (iterator.moveNext() && valueIterator.moveNext()) {
      headers.add(iterator.current, valueIterator.current);
    }
    return Headers._(headers);
  }

  factory Headers.fromEntries(Iterable<MapEntry<String, String>> iterable) {
    var headers = ListMultimap<String, String>();
    iterable.forEach((element) {
      headers.add(element.key.toLowerCase(), element.value);
    });
    return Headers._(headers);
  }

  @override
  Iterable<String> operator [](Object key) {
    return _namesAndValues[key];
  }

  @override
  void add(key, value) {
    _checkName(key);
    checkNotNull(key);
    checkNotNull(value);
    checkArgument(isNotBlank(key));
    checkArgument(isNotBlank(value));
    checkArgument(!key.contains('\t'));
    _checkValue(value);

    _namesAndValues.add(key, value);
  }

  @override
  void addAll(Multimap other) {
    _namesAndValues.addAll(other);
  }

  @override
  void addValues(key, Iterable values) {
    _namesAndValues.addValues(key, values);
  }

  @override
  Map<String, Iterable<String>> asMap() {
    return _namesAndValues.asMap();
  }

  @override
  void clear() {
    _namesAndValues.clear();
  }

  @override
  bool contains(Object key, Object value) {
    return _namesAndValues.contains(key, value);
  }

  @override
  bool containsKey(Object key) {
    return _namesAndValues.containsKey(key);
  }

  @override
  bool containsValue(Object value) {
    return _namesAndValues.containsValue(value);
  }

  @override
  void forEach(void Function(String key, String value) f) {
    _namesAndValues.forEach(f);
  }

  @override
  void forEachKey(void Function(String key, Iterable<String> value) f) {
    _namesAndValues.forEachKey(f);
  }

  @override
  bool get isEmpty => _namesAndValues.isEmpty;

  @override
  bool get isNotEmpty => _namesAndValues.isNotEmpty;

  @override
  Iterable<String> get keys => _namesAndValues.keys;

  @override
  int get length => _namesAndValues.length;

  @override
  bool remove(Object key, value) {
    return _namesAndValues.remove(key, value);
  }

  @override
  Iterable<String> removeAll(Object key) {
    return _namesAndValues.removeAll(key);
  }

  @override
  Iterable<String> get values => _namesAndValues.values;

  HeadersBuilder newBuilder() {
    return HeadersBuilder._(this);
  }

  Map<String, String> toMap() {
    return asMap().map((key, value) => MapEntry(key, value.join(', ')));
  }

  void _checkName(String name) {
    checkArgument(name.isNotEmpty, message: 'name is empty');
    checkArgument(_codeCheck(name, 33, 126));
  }

  void _checkValue(String name) {
    checkArgument(name.isNotEmpty, message: 'name is empty');
    checkArgument(_codeCheck(name, 32, 126) || name.contains('\t'));
  }

  bool _codeCheck(String text, int start, int end) {
    return text.codeUnits.every((ch) {
      return ch <= end && ch >= start;
    });
  }
}

class HeadersBuilder {
  HeadersBuilder();

  HeadersBuilder._(
    Headers headers,
  ) {
    _namesAndValues.addAll(headers);
  }

  final Multimap<String, String> _namesAndValues = ListMultimap();

  HeadersBuilder add(String name, String value) {
    _checkNameAndValue(name, value);
    addLenient(name, value);
    return this;
  }

  HeadersBuilder addLenient(String name, String value) {
    _namesAndValues.add(name.toLowerCase(), value);
    return this;
  }

  HeadersBuilder addLenientLine(String line) {
    var index = line.indexOf(':', 1);
    if (index != -1) {
      return addLenient(line.substring(0, index), line.substring(index + 1));
    } else if (line.startsWith(':')) {
      // Work around empty header names and header names that start with a
      // colon (created by old broken SPDY versions of the response cache).
      return addLenient('', line.substring(1)); // Empty header name.
    } else {
      return addLenient('', line); // No header name.
    }
  }

  HeadersBuilder removeAll(String name) {
    _namesAndValues.removeAll(name);
    return this;
  }

  HeadersBuilder set(String name, String value) {
    _checkNameAndValue(name, value);
    removeAll(name);
    addLenient(name, value);
    return this;
  }

  void _checkNameAndValue(String name, String value) {
    assert(name != null && name.isNotEmpty);
    assert(value != null);
  }

  Headers build() {
    return Headers._(_namesAndValues);
  }
}
