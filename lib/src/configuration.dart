import "dart:convert";

class Configuration {
  static String _cbREST_BASE_URL;
  static String _REST_User = 'ROBNEH01';
  static String _REST_Password = '+Robert0820#';
  // static String _REST_User = 'bond';
  // static String _REST_Password = '007';

  Configuration() {
    _cbREST_BASE_URL = r'https://codebeamer.b-h-c.de/api/v3';
    // _cbREST_BASE_URL = r'http://localhost:8080/api/v3';
  }

  String get RESTBaseURL {
    return _cbREST_BASE_URL;
  }

  String get REST_User {
    return _REST_User;
  }

  String get REST_Password {
    return _REST_Password;
  }

  String getAuthToken([String type = "Basic"]) {
    String token = base64.encode(utf8.encode("$REST_User:$REST_Password"));
    return "$type $token";
  }
}
