import 'package:http/http.dart' as http;
import 'dart:convert';
import '../src/configuration.dart';
import '../src/project.dart';
import '../src/helper.dart';
import '../src/tracker.dart';

Future<Tracker> documentTracker(Project project, Tracker tracker) async {
  Configuration config = Configuration();

  String homeServer = config.baseURLs['homeServer'];
  String docServer = config.baseURLs['documentationServer'];
  String path = '/api/v3/trackers/${tracker.id}';
  http.Response response;
  Tracker result;
  Map<String, dynamic> trackerData;
  int newItemID;

  /*
   * Retrieving details from project's tracker
   */
  try {
    response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
  } catch (e, stackTrace) {
    print('Error retrieving tracker: $e\n$stackTrace');
    return null;
  }

  if (response.statusCode != 200) {
    print('Retrieving failed with ${response.statusCode}\n${response.body}');
    return null;
  }

  newItemID = jsonDecode(response.body)['id'];
  trackerData = {
    'customFields': [
      {
        'fieldId': 10000,
        'name': 'trackerID',
        'title': 'Tracker ID',
        'type': 'IntegerFieldValue',
        'value': tracker.id,
      }
    ],
    'name': tracker.name,
    'description': tracker.description ??= '<not specified>',
  };

  try {
    path = '/api/v3/trackers/${config.docTrackers["Tracker"]}/items';
    response = await http.post(Uri.https(docServer, path),
        headers: httpHeader(), body: jsonEncode(trackerData));
  } catch (e, stackTrace) {
    print('Error posting tracker: $e\n$stackTrace');
    return null;
  }

  Map<String, dynamic> value = jsonDecode(response.body);

  tracker = Tracker.fromJson(value);
  tracker.trackerID = value['customFields'][0]['value'];

  if (response.statusCode != 200) {
    print(
        'Posting tracker failed with ${response.statusCode}\n${response.body}');
    return null;
  }
  return tracker;
}
