import 'package:freezed_annotation/freezed_annotation.dart';

part 'protocol.freezed.dart';

/// Protocols that OkHttp implements for [ALPN][ietf_alpn] selection.
///
/// ## Protocol vs Scheme
///
/// Despite its name, [java.net.URL.getProtocol] returns the [scheme][java.net.URI.getScheme] (http,
/// https, etc.) of the URL, not the protocol (http/1.1, spdy/3.1, etc.). OkHttp uses the word
/// *protocol* to identify how HTTP messages are framed.
///
/// [ietf_alpn]: http://tools.ietf.org/html/draft-ietf-tls-applayerprotoneg
@freezed
abstract class Protocol with _$Protocol {
  const factory Protocol(String protocol) = _Protocol;

  /// An obsolete plaintext framing that does not use persistent sockets by default.

  const factory Protocol.http1_0([@Default('http/1.0') String protocol]) =
      _HTTP_1_0;

  /// A plaintext framing that includes persistent connections.
  ///
  /// This version of OkHttp implements [RFC 7230][rfc_7230], and tracks revisions to that spec.
  ///
  /// [rfc_7230]: https://tools.ietf.org/html/rfc7230
  const factory Protocol.http1_1([@Default('http/1.1') String protocol]) =
      _HTTP_1_1;

  /// Chromium's binary-framed protocol that includes header compression, multiplexing multiple
  /// requests on the same socket, and server-push. HTTP/1.1 semantics are layered on SPDY/3.
  ///
  /// Current versions of OkHttp do not support this protocol.
  @Deprecated('OkHttp has dropped support for SPDY. Prefer {@link #HTTP_2}.')
  const factory Protocol.spdy3([@Default('spdy/3.1') String protocol]) =
      _SPDY_3;

  /// The IETF's binary-framed protocol that includes header compression, multiplexing multiple
  /// requests on the same socket, and server-push. HTTP/1.1 semantics are layered on HTTP/2.
  ///
  /// HTTP/2 requires deployments of HTTP/2 that use TLS 1.2 support
  /// [CipherSuite.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256], present in Java 8+ and Android 5+.
  /// Servers that enforce this may send an exception message including the string
  /// `INADEQUATE_SECURITY`.
  const factory Protocol.http2([@Default('h2') String protocol]) = _HTTP_2;

  /// Cleartext HTTP/2 with no "upgrade" round trip. This option requires the client to have prior
  /// knowledge that the server supports cleartext HTTP/2.
  ///
  /// See also [Starting HTTP/2 with Prior Knowledge][rfc_7540_34].
  ///
  /// [rfc_7540_34]: https://tools.ietf.org/html/rfc7540.section-3.4
  const factory Protocol.h2_prior_knowledge(
      [@Default('h2_prior_knowledge') String protocol]) = H2_PRIOR_KNOWLEDGE;

  /// QUIC (Quick UDP Internet Connection) is a new multiplexed and secure transport atop UDP,
  /// designed from the ground up and optimized for HTTP/2 semantics. HTTP/1.1 semantics are layered
  /// on HTTP/2.
  ///
  /// QUIC is not natively supported by OkHttp, but provided to allow a theoretical interceptor that
  /// provides support.
  const factory Protocol.quic([@Default('quic') String protocol]) = _QUIC;

  @override
  String toString() => protocol;

  /// Returns the protocol identified by `protocol`.
  ///
  /// @throws IOException if `protocol` is unknown.
  factory Protocol.get(String protocol) {
    switch (protocol) {
      case 'http/1.0':
        return Protocol.http1_0();
      case 'http/1.1':
        return Protocol.http1_1();
      case 'spdy/3.1':
        return Protocol.spdy3();
      case 'h2':
        return Protocol.http2();
      case 'h2_prior_knowledge':
        return Protocol.h2_prior_knowledge();
      case 'quic':
        return Protocol.quic();
    }
    throw ArgumentError('unsupported protocol');
  }

  static Protocol get HTTP_2 => Protocol.http2();
  static Protocol get HTTP_1_1 => Protocol.http1_1();
  static Protocol get HTTP_1_0 => Protocol.http1_0();
  static Protocol get SPDY_3 => Protocol.spdy3();
  static Protocol get QUIC => Protocol.quic();
}
