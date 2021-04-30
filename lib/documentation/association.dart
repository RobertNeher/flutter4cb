import 'package:http/http.dart' as http;
import 'dart:convert';
import '../src/configuration.dart';
import '../src/helper.dart';
import '../src/tracker.dart';
import '../src/project.dart';

void main(List<String> args) async {
  int projectID = int.parse(args[0]);
  String trackerName = args[1];

  Project project = await lookupProjectName(projectID);
  print(project.name);
  Tracker tracker = await lookupTrackerName(trackerName);
  print(tracker.name);

  associate(tracker, tracker.id, project);
  print('Done');
}

Future<bool> associate(Tracker from, int trackerID, Project to) async {
  final Configuration config = Configuration();
  final String path = '/api/v3/associations';
  final String docServer = config.baseURLs['documentationServer'];

  final Map<String, dynamic> associationData = {
    'from': {
      'id': trackerID,
      'name': from.name,
      'type': 'TrackerItemReference'
    },
    'to': {'id': to.id, 'name': to.name, 'type': 'TrackerItemReference'},
    'type': {
      'id': config.associationRole,
      'name': 'child',
      'type': 'AssociationTypeReference'
    },
    'propagatingSuspects': false,
    'reversePropagation': false,
    'biDirectionalPropagation': false,
  };
  print(associationData);
  http.Response response;

  try {
    response = await http.post(Uri.https(docServer, path),
        headers: httpHeader(), body: jsonEncode(associationData));
  } catch (e, stackTrace) {
    print('Error in setting association: $e\n$stackTrace');
    return false;
  }
  var result = jsonDecode(response.body);

  if (response.statusCode != 200) {
    print(
        'Posting association failed with ${response.statusCode}\n${response.body}');
    return false;
  }
  return true;
}
