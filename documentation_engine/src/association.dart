import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../lib/src/configuration.dart';
import '../../lib/src/helper.dart';
import '../../lib/src/tracker.dart';
import '../../lib/src/project.dart';

void main(List<String> args) async {
  int projectID = int.parse(args[0]);
  String trackerName = args[1];

  Project project = await lookupProjectName(projectID);
  print(project.name);
  Tracker tracker = await lookupTrackerName(trackerName);
  print(tracker.name);

  associate(tracker.id, project.id);
  print('Done');
}

Future<bool> associate(int from, int to) async {
  final Configuration config = Configuration();
  final String path = '/api/v3/associations';
  final String docServer = config.baseURLs['documentationServer'] as String;

  final Map<String, dynamic> associationData = {
    'from': {'id': from, 'type': 'TrackerItemReference'},
    'to': {'id': to, 'type': 'TrackerItemReference'},
    'type': {
      'id': config.associationRole,
      'name': config.associationName,
      'type': 'AssociationTypeReference'
    },
    'propagatingSuspects': false,
    'reversePropagation': false,
    'biDirectionalPropagation': false,
  };
  http.Response response;

  try {
    response = await http.post(Uri.https(docServer, path),
        headers: httpHeader(), body: jsonEncode(associationData));
  } catch (e, stackTrace) {
    print('Error in setting association: $e\n$stackTrace');
    return false;
  }

  switch (response.statusCode) {
    case 200: //new association established
      return true;
    case 400: // association exists already
      return true;
    default:
      {
        print(
            'Posting association failed with ${response.statusCode}\n${response.body}');
        return false;
      }
  }
}
