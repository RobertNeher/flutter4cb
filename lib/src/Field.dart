import 'dart:convert';

import 'configuration.dart';
import 'helper.dart';
import 'package:http/http.dart' as http;
import '../src/work_item.dart';

Future<void> main(List<String> args) async {
  Configuration config = Configuration();
  int trackerID = int.parse(args[0]);
  List<Field> fields = await fetchTrackerFields(trackerID);
  if (fields != null) {
    fields.forEach((field) async {
      print('${field.name}');
      bool fieldFound = await lookupFieldName(args[1]);

      if (fieldFound) {
        // Field fieldItem = (await documentField(trackerID, field.id));
        print(
            'Field ${field.name} (${field.type}) of tracker $trackerID is processed');
      }
    });
    print('No fields found');
  }

  // int i = 0;
  // fields.forEach((field) async {
  //   Field result;
  //   FieldDetail fd = await fetchFieldDetail(trackerID, field.id);
  //   print(
  //       '${i++}:${field.name} (${field.id}) is of type ${fd.type}: ${fd.description}');
  //   result = await lookupFieldName(docFields, field.name);
  //   print('...${result != null}');
  // });
}

Future<bool> lookupFieldName(String fieldName) async {
  bool value;
  Configuration config = Configuration();
  List<WorkItemPage> docFields =
      await fetchWorkItemPages(config.docTrackers['Field'] as int);

  docFields.forEach((page) {
    page.workItems.forEach((workItem) {
      // print('${workItem.name} == $fieldName');
      if (workItem.name == fieldName) {
        value = true;
        return;
      }
    });
  });
  return false;
}

Future<List<Field>> fetchTrackerFields(int trackerID) async {
  http.Response response;
  Configuration config = Configuration();
  String server = config.baseURLs['homeServer'] as String;
  String path = '/api/v3/trackers/$trackerID/fields';
  int i = 0;
  List<Field> fields;

  try {
    response = await http.get(Uri.https(server, path), headers: httpHeader());
  } catch (e, stackTrace) {
    print('Error in fetching tracker fields: $e: $stackTrace');
    return [];
  }
  if (response.statusCode != 200) {
    print('Error in fetching tracker fields');
    return [];
  }

  List fieldList = jsonDecode(response.body);
  fields = fieldList.map((field) => Field.fromJson(field)).toList();

  fields.forEach((field) async {
    FieldDetail fd = await fetchFieldDetail(trackerID, field.id);

    fields[i].description = fd.description;
    fields[i].type = fd.type;
    // fields[i].options = fd.options;
    i++;
  });
  return fields;
}

class Field {
  final int id;
  final String fieldID;
  final String name;
  String type;
  String description;
  // List<Option> options;

  Field({
    this.id = 0,
    this.fieldID = '',
    this.name = '',
    this.type = '',
    this.description = '',
    // this.options = <Option>[],
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      fieldID: json['fieldID'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      // options: []
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fieldID'] = this.fieldID;
    data['name'] = this.name;
    data['type'] = this.type;
    data['description'] = this.description;
    // data['options'] = this.options;
    return data;
  }
}

Future<FieldDetail> fetchFieldDetail(int trackerID, int fieldID) async {
  Configuration config = Configuration();
  String path = '/api/v3/trackers/$trackerID/fields/$fieldID';
  String server = config.baseURLs['homeServer'] as String;

  final response =
      await http.get(Uri.https(server, path), headers: httpHeader());

  if (response.statusCode != 200) {
    print("Error fetching field detail: ${response.statusCode}");
    return FieldDetail();
  }

  List<Option> options;
  Map<String, dynamic> json = jsonDecode(response.body);
  String type = json['type'];
  type = type.truncateTo(type.length - 'Field'.length);
  json['type'] = type;

  // if (type.startsWith('Option')) {
  //   var optionList = json['options'] as List;
  //   json['options'] =
  //       optionList.map((option) => Option.fromJson(option)).toList();
  // } else {
  //   json['options'] = null;
  // }
  return FieldDetail.fromJson(json);
}

class FieldDetail {
  final int id;
  final String name;
  final String type;
  final String description;
  // List<Option> options;

  FieldDetail(
      {this.id = 0,
      this.name = '',
      this.type = '',
      this.description = '',
      options});

  factory FieldDetail.fromJson(Map<String, dynamic> json) {
    return FieldDetail(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      // options: null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['description'] = this.description;
    // data['options'] = this.options;
    return data;
  }
}

class Option {
  final int id;
  final String name;

  Option({this.id = 0, this.name = ''});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
