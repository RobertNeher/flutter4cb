import 'package:http/http.dart' as http;
import 'dart:convert';
import '../src/configuration.dart';
import '../src/helper.dart';
import '../src/field.dart';

void main(List<String> args) async {
  Field result = await documentField(int.parse(args[0]), int.parse(args[1]));
  print('...and the winner is ${result.name}');
}

Future<Field> documentField(int trackerID, int fieldID) async {
  Field field;
  Configuration config = Configuration();

  String homeServer = config.baseURLs['homeServer'];
  String docServer = config.baseURLs['documentationServer'];
  String path = '/api/v3/trackers/$trackerID/fields/$fieldID';
  http.Response response;
  Map<String, dynamic> fieldData;

  try {
    response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
  } catch (e, stackTrace) {
    print('Error in fetching field details: $e: $stackTrace');
    return null;
  }
  if (response.statusCode != 200) {
    print('Error in fetching field details');
    return null;
  }
  field = Field.fromJson(jsonDecode(response.body));
  fieldData = {
    'description:': field.description,
    'customFields': [
      {
        'fieldId': 10000,
        // 'name': 'fieldID',
        // 'title': 'Field ID',
        // 'type': 'IntegerFieldValue',
        'value': fieldID,
      },
      // {
      //   'fieldId': 1000000,
      //   'name': 'options',
      //   'title': 'Options',
      //   'type': 'TableFieldValue',
      //   'value': generateOptionTable(fieldDetail.options),
      // }
    ],
    'name': field.name,
    'type': field.type,
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
    print('Field not posted: ${response.statusCode}');
    return null;
  }
  return Field.fromJson(jsonDecode(response.body));
  return field;
}
