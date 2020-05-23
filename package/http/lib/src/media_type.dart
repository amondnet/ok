import 'package:http_parser/http_parser.dart' show MediaType;

extension MediaTypeExtension on MediaType {
  String get charset {
    return parameters['charset'];
  }
}
