import "dart:convert";

class Configuration {
  static String _cbREST_BASE;
  static String _REST_User = 'ROBNEH01';
  static String _REST_Password = 'INfLuxTeREST';
  // static String _REST_User = 'bond';
  // static String _REST_Password = '007';

  Configuration() {
    _cbREST_BASE = 'codebeamer.b-h-c.de';
    // _cbREST_BASE = r'localhost:8080';
  }

  String get RESTBase {
    return _cbREST_BASE;
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
