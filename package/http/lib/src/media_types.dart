import 'package:http_parser/http_parser.dart';
import 'package:quiver/strings.dart';

class MediaTypes extends MediaType {
  MediaTypes(String type, String subtype, [param])
      : super(type, subtype, param);

  static MediaTypes get(String contentType) {
    var mediaType = MediaType.parse(contentType);
    var parameters = Map.of(mediaType.parameters);
    parameters['charset'] = mediaType.charset();
    return MediaTypes(mediaType.type, mediaType.subtype, parameters);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaTypes && runtimeType == other.runtimeType;

  @override
  int get hashCode {
    return type.hashCode + subtype.hashCode + parameters.hashCode;
  }
}

extension MediaTypeEext on MediaType {
  String charset([String defaultValue = 'utf-8']) {
    return parameters['charset'] ?? defaultValue;
  }
}

extension MediaTypeStringExtension on String {
  MediaTypes toMediaType() {
    return MediaTypes.get(this);
  }
}
