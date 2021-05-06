import 'configuration.dart';

extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (this.length <= maxLength) ? this : '${this.substring(0, maxLength)}...';
}

Map<String, String> httpHeader() {
  Configuration config = Configuration();

  return {
    'accept': 'application/json',
    'content-type': 'application/json',
    'authorization': config.getAuthToken(),
    // 'charset': 'utf8',
    // 'Access-control-allow-origin': '*',
    // 'Access-Control-Allow-Headers': '*',
    // 'Access-Control-Allow-Methods': 'POST,GET,DELETE,PUT,OPTIONS',
  };
}
