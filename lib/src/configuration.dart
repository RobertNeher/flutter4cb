import 'dart:collection';
import "dart:convert";

class Configuration {
  static String _REST_User = 'ROBNEH01';
  static String _REST_Password = 'INfLuxTeREST';
  Map<String, int> _fieldTypes = Map<String, int>();
  // static String _REST_User = 'bond';
  // static String _REST_Password = '007';

  Configuration() {
    _fieldTypes.addAll({'Text': 0});
    _fieldTypes.addAll({'Integer': 1});
    _fieldTypes.addAll({'Decimal': 2});
    _fieldTypes.addAll({'Color': 4});
    _fieldTypes.addAll({'Duration': 5});
    _fieldTypes.addAll({'Bool': 6});
    _fieldTypes.addAll({'Language': 7});
    _fieldTypes.addAll({'Country': 8});
    _fieldTypes.addAll({'WikiText': 9});
    _fieldTypes.addAll({'Url': 10});
    _fieldTypes.addAll({'Date': 11});
    _fieldTypes.addAll({'Table': 1000});
  }

  static int _documentationProjectID = 7;
  static int _associcationRole = 3;
  static String _associcationName = 'child';

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

  String get associationName {
    return _associcationName;
  }

  int get associationRole {
    return _associcationRole;
  }

  int get documentationProjectID {
    return _documentationProjectID;
  }

  Map<String, int> get docTrackers {
    return _trackers;
  }

  Map<String, int> get fieldTypes {
    return _fieldTypes;
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
