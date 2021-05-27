import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../lib/src/configuration.dart';
import '../../lib/src/helper.dart';
import '../../lib/src/field.dart';

Future<Field?> documentField(int trackerID, int fieldID) async {
  Field field;
  Configuration config = Configuration();

  String homeServer = config.baseURLs['homeServer'] as String;
  String docServer = config.baseURLs['documentationServer'] as String;
  String path = '/api/v3/trackers/$trackerID/fields/$fieldID';
  http.Response response;
  Map<String, dynamic> fieldData;
  int newID;

  /*
   * Retrieving details from tracker's field
   */
  try {
    response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
  } catch (e, stackTrace) {
    print('Error in retrieving field details: $e: $stackTrace');
    return null;
  }
  if (response.statusCode != 200) {
    print(
        'Error in retrieving field details: ${response.statusCode}: ${response.body}');
    return null;
  }
  field = Field.fromJson(jsonDecode(response.body));
  fieldData = {
    'category': [
      {
        'id': config.fieldTypes[field.type],
        'name': field.type,
      }
    ],
    'customFields': [
      {
        'fieldId': 10001,
        'name': 'fieldID',
        'title': 'Field ID',
        'type': 'IntegerFieldValue',
        'value': field.id.toString(),
      }
      // {
      //   'fieldId': 1000000,
      //   'name': 'options',
      //   'title': 'Options',
      //   'type': 'TableFieldValue',
      //   'value': generateOptionTable(fieldDetail.options),
      // }
    ],
    'name': field.name,
    'description': field.description,
  };
  path = '/api/v3/trackers/${config.docTrackers["Field"]}/items';

  try {
    response = await http.post(Uri.https(docServer, path),
        headers: httpHeader(), body: jsonEncode(fieldData));
  } catch (e, stackTrace) {
    print('Error in posting field data: $e: $stackTrace');
    return null;
  }
  if (response.statusCode != 200) {
    print(
        'Field not posted: ${response.statusCode}: ${jsonDecode(response.body)}');
    return null;
  }
  newID = jsonDecode(response.body)['id'];
  return Field.fromJson(jsonDecode(response.body));
}

void main(List<String> args) async {
  Field result =
      await documentField(int.parse(args[0]), int.parse(args[1])) as Field;
  if (result != null) {
    print('...and the winner is ${result.name}');
  }
}
