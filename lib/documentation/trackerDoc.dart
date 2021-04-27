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
  String path = '/api/v3/trackers/${tracker.trackerID}';
  http.Response response;
  Map<String, dynamic> trackerData;
  int newItemID;

  /*
   * Retrieving details from project's tracker
   */
  try {
    response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
  } catch (e, stackTrace) {
    return null;
  }
  if (response.statusCode == 200) {
    newItemID = jsonDecode(response.body)['id'];
    tracker = Tracker.fromJson(jsonDecode(response.body));
    trackerData = {
      'customFields': [
        {
          'fieldId': 10000,
          'name': 'TrackerID',
          'type': 'IntegerFieldValue',
          'value': tracker.trackerID
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
      return null;
    }

    trackerData = {
      'name': 'belongs to',
      'description':
          'This tracker is associated with project ${project.name} (${project.id})',
      'from': {'id': project.id, 'name': project.name, 'type': 'child'},
      'to': {'id': newItemID, 'name': tracker.name, 'type': 'parent'},
      'propagatingSuspects': true,
      'reversePropagation': false,
      'biDirectionalPropagation': false,
      'propagatingDependencies': true,
    };

    try {
      path = '/api/v3/associations';
      response = await http.post(Uri.https(docServer, path),
          headers: httpHeader(), body: jsonEncode(trackerData));
    } catch (e, stackTrace) {
      return null;
    }
  }
  return tracker;
}
