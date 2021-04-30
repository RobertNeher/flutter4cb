import 'dart:convert';
import 'configuration.dart';
import 'helper.dart';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  List<Field> fields = await fetchFields(int.parse(args[0], int.parse(args[1]));

  fields.forEach((field) async {
    print(
        '${field.name} (${field.id})is of type ${field.type}: ${field.description}');
  });
}


Future<List<Field>> fetchFields(int trackerID, int fieldID) async {
  List<Field> fields;
  Configuration config = Configuration();

  final response = await http.get(
      Uri.https(
          config.baseURLs['homeServer'], '/api/v3/trackers/$trackerID/fields'),
      headers: httpHeader());

  if (response.statusCode == 200) {
    List jsonRaw = jsonDecode(response.body);

    fields = jsonRaw.map((item) => Field.fromJson(item)).toList();
  } else
    print("Error ${response.statusCode}");

  return fields;
}

class Field {
  final int id;
  final String name;
  final String type;
  final String description;

  Field({this.id, this.name, this.type, this.description});

  factory Field.fromJson(Map<String, dynamic> json) {
    switch json['type'] {
      case 'IntegerField'
    }
    return Field(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        description: json['description']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['description'] = this.description;
    return data;
  }

  String _evaluateType(String type) {

  }
}
