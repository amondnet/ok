class MediaType {
  final String mediaType;
  final String type;
  final String subtype;
  final String _charset;

  MediaType._(this.mediaType, this.type, this.subtype, this._charset);

  String charset([String defaultValue]) {
    return _charset ?? defaultValue;
  }

  @override
  String toString() => mediaType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaType &&
          runtimeType == other.runtimeType &&
          mediaType == other.mediaType;

  @override
  int get hashCode => mediaType.hashCode;
}

const String TOKEN = "([a-zA-Z0-9-!#\$%&'*+.^_`{|}~]+)";

const String QUOTED = '\"([^\"]*)\"';

final RegExp TYPE_SUBTYPE = RegExp(r'$TOKEN/$TOKEN');
final RegExp PARAMETER = RegExp(r';\\s*(?:$TOKEN=(?:$TOKEN|$QUOTED))?');

extension on String {
  MediaType toMediaType() {
    final typeSubtype = TYPE_SUBTYPE.allMatches(this).toList();
    final type = typeSubtype[0].toString().toLowerCase();
    final subtype = typeSubtype[1].toString().toLowerCase();

    var charset;
    final parameter = PARAMETER.allMatches(this);
    var s = typeSubtype.length;
    while ( s < this.length) {
      parameter.re
    }

  }
}
