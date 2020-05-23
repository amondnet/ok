// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'protocol.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$ProtocolTearOff {
  const _$ProtocolTearOff();

  _Protocol call(String protocol) {
    return _Protocol(
      protocol,
    );
  }

  _HTTP_1_0 http1_0([String protocol = 'http/1.0']) {
    return _HTTP_1_0(
      protocol,
    );
  }

  _HTTP_1_1 http1_1([String protocol = 'http/1.1']) {
    return _HTTP_1_1(
      protocol,
    );
  }

  _SPDY_3 spdy3([String protocol = 'spdy/3.1']) {
    return _SPDY_3(
      protocol,
    );
  }

  _HTTP_2 http2([String protocol = 'h2']) {
    return _HTTP_2(
      protocol,
    );
  }

  H2_PRIOR_KNOWLEDGE h2_prior_knowledge(
      [String protocol = 'h2_prior_knowledge']) {
    return H2_PRIOR_KNOWLEDGE(
      protocol,
    );
  }

  _QUIC quic([String protocol = 'quic']) {
    return _QUIC(
      protocol,
    );
  }
}

// ignore: unused_element
const $Protocol = _$ProtocolTearOff();

mixin _$Protocol {
  String get protocol;

  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(String protocol), {
    @required Result http1_0(String protocol),
    @required Result http1_1(String protocol),
    @required Result spdy3(String protocol),
    @required Result http2(String protocol),
    @required Result h2_prior_knowledge(String protocol),
    @required Result quic(String protocol),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(String protocol), {
    Result http1_0(String protocol),
    Result http1_1(String protocol),
    Result spdy3(String protocol),
    Result http2(String protocol),
    Result h2_prior_knowledge(String protocol),
    Result quic(String protocol),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_Protocol value), {
    @required Result http1_0(_HTTP_1_0 value),
    @required Result http1_1(_HTTP_1_1 value),
    @required Result spdy3(_SPDY_3 value),
    @required Result http2(_HTTP_2 value),
    @required Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    @required Result quic(_QUIC value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_Protocol value), {
    Result http1_0(_HTTP_1_0 value),
    Result http1_1(_HTTP_1_1 value),
    Result spdy3(_SPDY_3 value),
    Result http2(_HTTP_2 value),
    Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    Result quic(_QUIC value),
    @required Result orElse(),
  });

  $ProtocolCopyWith<Protocol> get copyWith;
}

abstract class $ProtocolCopyWith<$Res> {
  factory $ProtocolCopyWith(Protocol value, $Res Function(Protocol) then) =
      _$ProtocolCopyWithImpl<$Res>;
  $Res call({String protocol});
}

class _$ProtocolCopyWithImpl<$Res> implements $ProtocolCopyWith<$Res> {
  _$ProtocolCopyWithImpl(this._value, this._then);

  final Protocol _value;
  // ignore: unused_field
  final $Res Function(Protocol) _then;

  @override
  $Res call({
    Object protocol = freezed,
  }) {
    return _then(_value.copyWith(
      protocol: protocol == freezed ? _value.protocol : protocol as String,
    ));
  }
}

abstract class _$ProtocolCopyWith<$Res> implements $ProtocolCopyWith<$Res> {
  factory _$ProtocolCopyWith(_Protocol value, $Res Function(_Protocol) then) =
      __$ProtocolCopyWithImpl<$Res>;
  @override
  $Res call({String protocol});
}

class __$ProtocolCopyWithImpl<$Res> extends _$ProtocolCopyWithImpl<$Res>
    implements _$ProtocolCopyWith<$Res> {
  __$ProtocolCopyWithImpl(_Protocol _value, $Res Function(_Protocol) _then)
      : super(_value, (v) => _then(v as _Protocol));

  @override
  _Protocol get _value => super._value as _Protocol;

  @override
  $Res call({
    Object protocol = freezed,
  }) {
    return _then(_Protocol(
      protocol == freezed ? _value.protocol : protocol as String,
    ));
  }
}

class _$_Protocol implements _Protocol {
  const _$_Protocol(this.protocol) : assert(protocol != null);

  @override
  final String protocol;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Protocol &&
            (identical(other.protocol, protocol) ||
                const DeepCollectionEquality()
                    .equals(other.protocol, protocol)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(protocol);

  @override
  _$ProtocolCopyWith<_Protocol> get copyWith =>
      __$ProtocolCopyWithImpl<_Protocol>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(String protocol), {
    @required Result http1_0(String protocol),
    @required Result http1_1(String protocol),
    @required Result spdy3(String protocol),
    @required Result http2(String protocol),
    @required Result h2_prior_knowledge(String protocol),
    @required Result quic(String protocol),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return $default(protocol);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(String protocol), {
    Result http1_0(String protocol),
    Result http1_1(String protocol),
    Result spdy3(String protocol),
    Result http2(String protocol),
    Result h2_prior_knowledge(String protocol),
    Result quic(String protocol),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(protocol);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_Protocol value), {
    @required Result http1_0(_HTTP_1_0 value),
    @required Result http1_1(_HTTP_1_1 value),
    @required Result spdy3(_SPDY_3 value),
    @required Result http2(_HTTP_2 value),
    @required Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    @required Result quic(_QUIC value),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return $default(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_Protocol value), {
    Result http1_0(_HTTP_1_0 value),
    Result http1_1(_HTTP_1_1 value),
    Result spdy3(_SPDY_3 value),
    Result http2(_HTTP_2 value),
    Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    Result quic(_QUIC value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _Protocol implements Protocol {
  const factory _Protocol(String protocol) = _$_Protocol;

  @override
  String get protocol;
  @override
  _$ProtocolCopyWith<_Protocol> get copyWith;
}

abstract class _$HTTP_1_0CopyWith<$Res> implements $ProtocolCopyWith<$Res> {
  factory _$HTTP_1_0CopyWith(_HTTP_1_0 value, $Res Function(_HTTP_1_0) then) =
      __$HTTP_1_0CopyWithImpl<$Res>;
  @override
  $Res call({String protocol});
}

class __$HTTP_1_0CopyWithImpl<$Res> extends _$ProtocolCopyWithImpl<$Res>
    implements _$HTTP_1_0CopyWith<$Res> {
  __$HTTP_1_0CopyWithImpl(_HTTP_1_0 _value, $Res Function(_HTTP_1_0) _then)
      : super(_value, (v) => _then(v as _HTTP_1_0));

  @override
  _HTTP_1_0 get _value => super._value as _HTTP_1_0;

  @override
  $Res call({
    Object protocol = freezed,
  }) {
    return _then(_HTTP_1_0(
      protocol == freezed ? _value.protocol : protocol as String,
    ));
  }
}

class _$_HTTP_1_0 implements _HTTP_1_0 {
  const _$_HTTP_1_0([this.protocol = 'http/1.0']) : assert(protocol != null);

  @JsonKey(defaultValue: 'http/1.0')
  @override
  final String protocol;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HTTP_1_0 &&
            (identical(other.protocol, protocol) ||
                const DeepCollectionEquality()
                    .equals(other.protocol, protocol)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(protocol);

  @override
  _$HTTP_1_0CopyWith<_HTTP_1_0> get copyWith =>
      __$HTTP_1_0CopyWithImpl<_HTTP_1_0>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(String protocol), {
    @required Result http1_0(String protocol),
    @required Result http1_1(String protocol),
    @required Result spdy3(String protocol),
    @required Result http2(String protocol),
    @required Result h2_prior_knowledge(String protocol),
    @required Result quic(String protocol),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return http1_0(protocol);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(String protocol), {
    Result http1_0(String protocol),
    Result http1_1(String protocol),
    Result spdy3(String protocol),
    Result http2(String protocol),
    Result h2_prior_knowledge(String protocol),
    Result quic(String protocol),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (http1_0 != null) {
      return http1_0(protocol);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_Protocol value), {
    @required Result http1_0(_HTTP_1_0 value),
    @required Result http1_1(_HTTP_1_1 value),
    @required Result spdy3(_SPDY_3 value),
    @required Result http2(_HTTP_2 value),
    @required Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    @required Result quic(_QUIC value),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return http1_0(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_Protocol value), {
    Result http1_0(_HTTP_1_0 value),
    Result http1_1(_HTTP_1_1 value),
    Result spdy3(_SPDY_3 value),
    Result http2(_HTTP_2 value),
    Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    Result quic(_QUIC value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (http1_0 != null) {
      return http1_0(this);
    }
    return orElse();
  }
}

abstract class _HTTP_1_0 implements Protocol {
  const factory _HTTP_1_0([String protocol]) = _$_HTTP_1_0;

  @override
  String get protocol;
  @override
  _$HTTP_1_0CopyWith<_HTTP_1_0> get copyWith;
}

abstract class _$HTTP_1_1CopyWith<$Res> implements $ProtocolCopyWith<$Res> {
  factory _$HTTP_1_1CopyWith(_HTTP_1_1 value, $Res Function(_HTTP_1_1) then) =
      __$HTTP_1_1CopyWithImpl<$Res>;
  @override
  $Res call({String protocol});
}

class __$HTTP_1_1CopyWithImpl<$Res> extends _$ProtocolCopyWithImpl<$Res>
    implements _$HTTP_1_1CopyWith<$Res> {
  __$HTTP_1_1CopyWithImpl(_HTTP_1_1 _value, $Res Function(_HTTP_1_1) _then)
      : super(_value, (v) => _then(v as _HTTP_1_1));

  @override
  _HTTP_1_1 get _value => super._value as _HTTP_1_1;

  @override
  $Res call({
    Object protocol = freezed,
  }) {
    return _then(_HTTP_1_1(
      protocol == freezed ? _value.protocol : protocol as String,
    ));
  }
}

class _$_HTTP_1_1 implements _HTTP_1_1 {
  const _$_HTTP_1_1([this.protocol = 'http/1.1']) : assert(protocol != null);

  @JsonKey(defaultValue: 'http/1.1')
  @override
  final String protocol;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HTTP_1_1 &&
            (identical(other.protocol, protocol) ||
                const DeepCollectionEquality()
                    .equals(other.protocol, protocol)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(protocol);

  @override
  _$HTTP_1_1CopyWith<_HTTP_1_1> get copyWith =>
      __$HTTP_1_1CopyWithImpl<_HTTP_1_1>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(String protocol), {
    @required Result http1_0(String protocol),
    @required Result http1_1(String protocol),
    @required Result spdy3(String protocol),
    @required Result http2(String protocol),
    @required Result h2_prior_knowledge(String protocol),
    @required Result quic(String protocol),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return http1_1(protocol);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(String protocol), {
    Result http1_0(String protocol),
    Result http1_1(String protocol),
    Result spdy3(String protocol),
    Result http2(String protocol),
    Result h2_prior_knowledge(String protocol),
    Result quic(String protocol),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (http1_1 != null) {
      return http1_1(protocol);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_Protocol value), {
    @required Result http1_0(_HTTP_1_0 value),
    @required Result http1_1(_HTTP_1_1 value),
    @required Result spdy3(_SPDY_3 value),
    @required Result http2(_HTTP_2 value),
    @required Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    @required Result quic(_QUIC value),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return http1_1(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_Protocol value), {
    Result http1_0(_HTTP_1_0 value),
    Result http1_1(_HTTP_1_1 value),
    Result spdy3(_SPDY_3 value),
    Result http2(_HTTP_2 value),
    Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    Result quic(_QUIC value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (http1_1 != null) {
      return http1_1(this);
    }
    return orElse();
  }
}

abstract class _HTTP_1_1 implements Protocol {
  const factory _HTTP_1_1([String protocol]) = _$_HTTP_1_1;

  @override
  String get protocol;
  @override
  _$HTTP_1_1CopyWith<_HTTP_1_1> get copyWith;
}

abstract class _$SPDY_3CopyWith<$Res> implements $ProtocolCopyWith<$Res> {
  factory _$SPDY_3CopyWith(_SPDY_3 value, $Res Function(_SPDY_3) then) =
      __$SPDY_3CopyWithImpl<$Res>;
  @override
  $Res call({String protocol});
}

class __$SPDY_3CopyWithImpl<$Res> extends _$ProtocolCopyWithImpl<$Res>
    implements _$SPDY_3CopyWith<$Res> {
  __$SPDY_3CopyWithImpl(_SPDY_3 _value, $Res Function(_SPDY_3) _then)
      : super(_value, (v) => _then(v as _SPDY_3));

  @override
  _SPDY_3 get _value => super._value as _SPDY_3;

  @override
  $Res call({
    Object protocol = freezed,
  }) {
    return _then(_SPDY_3(
      protocol == freezed ? _value.protocol : protocol as String,
    ));
  }
}

@Deprecated('OkHttp has dropped support for SPDY. Prefer {@link #HTTP_2}.')
class _$_SPDY_3 implements _SPDY_3 {
  const _$_SPDY_3([this.protocol = 'spdy/3.1']) : assert(protocol != null);

  @JsonKey(defaultValue: 'spdy/3.1')
  @override
  final String protocol;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SPDY_3 &&
            (identical(other.protocol, protocol) ||
                const DeepCollectionEquality()
                    .equals(other.protocol, protocol)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(protocol);

  @override
  _$SPDY_3CopyWith<_SPDY_3> get copyWith =>
      __$SPDY_3CopyWithImpl<_SPDY_3>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(String protocol), {
    @required Result http1_0(String protocol),
    @required Result http1_1(String protocol),
    @required Result spdy3(String protocol),
    @required Result http2(String protocol),
    @required Result h2_prior_knowledge(String protocol),
    @required Result quic(String protocol),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return spdy3(protocol);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(String protocol), {
    Result http1_0(String protocol),
    Result http1_1(String protocol),
    Result spdy3(String protocol),
    Result http2(String protocol),
    Result h2_prior_knowledge(String protocol),
    Result quic(String protocol),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (spdy3 != null) {
      return spdy3(protocol);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_Protocol value), {
    @required Result http1_0(_HTTP_1_0 value),
    @required Result http1_1(_HTTP_1_1 value),
    @required Result spdy3(_SPDY_3 value),
    @required Result http2(_HTTP_2 value),
    @required Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    @required Result quic(_QUIC value),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return spdy3(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_Protocol value), {
    Result http1_0(_HTTP_1_0 value),
    Result http1_1(_HTTP_1_1 value),
    Result spdy3(_SPDY_3 value),
    Result http2(_HTTP_2 value),
    Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    Result quic(_QUIC value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (spdy3 != null) {
      return spdy3(this);
    }
    return orElse();
  }
}

abstract class _SPDY_3 implements Protocol {
  const factory _SPDY_3([String protocol]) = _$_SPDY_3;

  @override
  String get protocol;
  @override
  _$SPDY_3CopyWith<_SPDY_3> get copyWith;
}

abstract class _$HTTP_2CopyWith<$Res> implements $ProtocolCopyWith<$Res> {
  factory _$HTTP_2CopyWith(_HTTP_2 value, $Res Function(_HTTP_2) then) =
      __$HTTP_2CopyWithImpl<$Res>;
  @override
  $Res call({String protocol});
}

class __$HTTP_2CopyWithImpl<$Res> extends _$ProtocolCopyWithImpl<$Res>
    implements _$HTTP_2CopyWith<$Res> {
  __$HTTP_2CopyWithImpl(_HTTP_2 _value, $Res Function(_HTTP_2) _then)
      : super(_value, (v) => _then(v as _HTTP_2));

  @override
  _HTTP_2 get _value => super._value as _HTTP_2;

  @override
  $Res call({
    Object protocol = freezed,
  }) {
    return _then(_HTTP_2(
      protocol == freezed ? _value.protocol : protocol as String,
    ));
  }
}

class _$_HTTP_2 implements _HTTP_2 {
  const _$_HTTP_2([this.protocol = 'h2']) : assert(protocol != null);

  @JsonKey(defaultValue: 'h2')
  @override
  final String protocol;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HTTP_2 &&
            (identical(other.protocol, protocol) ||
                const DeepCollectionEquality()
                    .equals(other.protocol, protocol)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(protocol);

  @override
  _$HTTP_2CopyWith<_HTTP_2> get copyWith =>
      __$HTTP_2CopyWithImpl<_HTTP_2>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(String protocol), {
    @required Result http1_0(String protocol),
    @required Result http1_1(String protocol),
    @required Result spdy3(String protocol),
    @required Result http2(String protocol),
    @required Result h2_prior_knowledge(String protocol),
    @required Result quic(String protocol),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return http2(protocol);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(String protocol), {
    Result http1_0(String protocol),
    Result http1_1(String protocol),
    Result spdy3(String protocol),
    Result http2(String protocol),
    Result h2_prior_knowledge(String protocol),
    Result quic(String protocol),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (http2 != null) {
      return http2(protocol);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_Protocol value), {
    @required Result http1_0(_HTTP_1_0 value),
    @required Result http1_1(_HTTP_1_1 value),
    @required Result spdy3(_SPDY_3 value),
    @required Result http2(_HTTP_2 value),
    @required Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    @required Result quic(_QUIC value),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return http2(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_Protocol value), {
    Result http1_0(_HTTP_1_0 value),
    Result http1_1(_HTTP_1_1 value),
    Result spdy3(_SPDY_3 value),
    Result http2(_HTTP_2 value),
    Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    Result quic(_QUIC value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (http2 != null) {
      return http2(this);
    }
    return orElse();
  }
}

abstract class _HTTP_2 implements Protocol {
  const factory _HTTP_2([String protocol]) = _$_HTTP_2;

  @override
  String get protocol;
  @override
  _$HTTP_2CopyWith<_HTTP_2> get copyWith;
}

abstract class $H2_PRIOR_KNOWLEDGECopyWith<$Res>
    implements $ProtocolCopyWith<$Res> {
  factory $H2_PRIOR_KNOWLEDGECopyWith(
          H2_PRIOR_KNOWLEDGE value, $Res Function(H2_PRIOR_KNOWLEDGE) then) =
      _$H2_PRIOR_KNOWLEDGECopyWithImpl<$Res>;
  @override
  $Res call({String protocol});
}

class _$H2_PRIOR_KNOWLEDGECopyWithImpl<$Res>
    extends _$ProtocolCopyWithImpl<$Res>
    implements $H2_PRIOR_KNOWLEDGECopyWith<$Res> {
  _$H2_PRIOR_KNOWLEDGECopyWithImpl(
      H2_PRIOR_KNOWLEDGE _value, $Res Function(H2_PRIOR_KNOWLEDGE) _then)
      : super(_value, (v) => _then(v as H2_PRIOR_KNOWLEDGE));

  @override
  H2_PRIOR_KNOWLEDGE get _value => super._value as H2_PRIOR_KNOWLEDGE;

  @override
  $Res call({
    Object protocol = freezed,
  }) {
    return _then(H2_PRIOR_KNOWLEDGE(
      protocol == freezed ? _value.protocol : protocol as String,
    ));
  }
}

class _$H2_PRIOR_KNOWLEDGE implements H2_PRIOR_KNOWLEDGE {
  const _$H2_PRIOR_KNOWLEDGE([this.protocol = 'h2_prior_knowledge'])
      : assert(protocol != null);

  @JsonKey(defaultValue: 'h2_prior_knowledge')
  @override
  final String protocol;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is H2_PRIOR_KNOWLEDGE &&
            (identical(other.protocol, protocol) ||
                const DeepCollectionEquality()
                    .equals(other.protocol, protocol)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(protocol);

  @override
  $H2_PRIOR_KNOWLEDGECopyWith<H2_PRIOR_KNOWLEDGE> get copyWith =>
      _$H2_PRIOR_KNOWLEDGECopyWithImpl<H2_PRIOR_KNOWLEDGE>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(String protocol), {
    @required Result http1_0(String protocol),
    @required Result http1_1(String protocol),
    @required Result spdy3(String protocol),
    @required Result http2(String protocol),
    @required Result h2_prior_knowledge(String protocol),
    @required Result quic(String protocol),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return h2_prior_knowledge(protocol);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(String protocol), {
    Result http1_0(String protocol),
    Result http1_1(String protocol),
    Result spdy3(String protocol),
    Result http2(String protocol),
    Result h2_prior_knowledge(String protocol),
    Result quic(String protocol),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (h2_prior_knowledge != null) {
      return h2_prior_knowledge(protocol);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_Protocol value), {
    @required Result http1_0(_HTTP_1_0 value),
    @required Result http1_1(_HTTP_1_1 value),
    @required Result spdy3(_SPDY_3 value),
    @required Result http2(_HTTP_2 value),
    @required Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    @required Result quic(_QUIC value),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return h2_prior_knowledge(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_Protocol value), {
    Result http1_0(_HTTP_1_0 value),
    Result http1_1(_HTTP_1_1 value),
    Result spdy3(_SPDY_3 value),
    Result http2(_HTTP_2 value),
    Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    Result quic(_QUIC value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (h2_prior_knowledge != null) {
      return h2_prior_knowledge(this);
    }
    return orElse();
  }
}

abstract class H2_PRIOR_KNOWLEDGE implements Protocol {
  const factory H2_PRIOR_KNOWLEDGE([String protocol]) = _$H2_PRIOR_KNOWLEDGE;

  @override
  String get protocol;
  @override
  $H2_PRIOR_KNOWLEDGECopyWith<H2_PRIOR_KNOWLEDGE> get copyWith;
}

abstract class _$QUICCopyWith<$Res> implements $ProtocolCopyWith<$Res> {
  factory _$QUICCopyWith(_QUIC value, $Res Function(_QUIC) then) =
      __$QUICCopyWithImpl<$Res>;
  @override
  $Res call({String protocol});
}

class __$QUICCopyWithImpl<$Res> extends _$ProtocolCopyWithImpl<$Res>
    implements _$QUICCopyWith<$Res> {
  __$QUICCopyWithImpl(_QUIC _value, $Res Function(_QUIC) _then)
      : super(_value, (v) => _then(v as _QUIC));

  @override
  _QUIC get _value => super._value as _QUIC;

  @override
  $Res call({
    Object protocol = freezed,
  }) {
    return _then(_QUIC(
      protocol == freezed ? _value.protocol : protocol as String,
    ));
  }
}

class _$_QUIC implements _QUIC {
  const _$_QUIC([this.protocol = 'quic']) : assert(protocol != null);

  @JsonKey(defaultValue: 'quic')
  @override
  final String protocol;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _QUIC &&
            (identical(other.protocol, protocol) ||
                const DeepCollectionEquality()
                    .equals(other.protocol, protocol)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(protocol);

  @override
  _$QUICCopyWith<_QUIC> get copyWith =>
      __$QUICCopyWithImpl<_QUIC>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(String protocol), {
    @required Result http1_0(String protocol),
    @required Result http1_1(String protocol),
    @required Result spdy3(String protocol),
    @required Result http2(String protocol),
    @required Result h2_prior_knowledge(String protocol),
    @required Result quic(String protocol),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return quic(protocol);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(String protocol), {
    Result http1_0(String protocol),
    Result http1_1(String protocol),
    Result spdy3(String protocol),
    Result http2(String protocol),
    Result h2_prior_knowledge(String protocol),
    Result quic(String protocol),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (quic != null) {
      return quic(protocol);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_Protocol value), {
    @required Result http1_0(_HTTP_1_0 value),
    @required Result http1_1(_HTTP_1_1 value),
    @required Result spdy3(_SPDY_3 value),
    @required Result http2(_HTTP_2 value),
    @required Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    @required Result quic(_QUIC value),
  }) {
    assert($default != null);
    assert(http1_0 != null);
    assert(http1_1 != null);
    assert(spdy3 != null);
    assert(http2 != null);
    assert(h2_prior_knowledge != null);
    assert(quic != null);
    return quic(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_Protocol value), {
    Result http1_0(_HTTP_1_0 value),
    Result http1_1(_HTTP_1_1 value),
    Result spdy3(_SPDY_3 value),
    Result http2(_HTTP_2 value),
    Result h2_prior_knowledge(H2_PRIOR_KNOWLEDGE value),
    Result quic(_QUIC value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (quic != null) {
      return quic(this);
    }
    return orElse();
  }
}

abstract class _QUIC implements Protocol {
  const factory _QUIC([String protocol]) = _$_QUIC;

  @override
  String get protocol;
  @override
  _$QUICCopyWith<_QUIC> get copyWith;
}
