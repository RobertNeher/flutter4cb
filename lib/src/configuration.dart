import "dart:convert";

class Configuration {
  static String _REST_User = 'ROBNEH01';
  static String _REST_Password = 'INfLuxTeREST';
  // static String _REST_User = 'bond';
  // static String _REST_Password = '007';

  static int _documentationProjectID = 7;

  static Map<String, int> _trackers = {
    'Project': 11739,
    'Tracker': 11421,
    'Field': 11507,
    'Option': 11593,
    'Status': 11665,
  };

  static Map<String, String> _baseURLs = {
    'homeServer': 'codebeamer.b-h-c.de',
    'documentationServer': 'codebeamer.b-h-c.de',
  };


  Map<String, String> get baseURLs {
    return _baseURLs;
  }

  int get documentationProjectID {
    return _documentationProjectID;
  }

  Map<String, int> get docTrackers {
    return _trackers;
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
