import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'dart:convert';
import '../src/configuration.dart';
import '../src/helper.dart';
import '../src/tracker.dart';

Future<int> documentTracker(int projectID, int trackerID) async {
  final log =
      Logger('TrackerDoc for project $projectID and tracker $trackerID');

  Configuration config = Configuration();
  Tracker tracker;

  String homeServer = config.baseURLs['homeServer'];
  String docServer = config.baseURLs['documentationServer'];
  String path = '/api/v3/trackers/$trackerID';
  http.Response response;
  Map<String, dynamic> trackerData;

  try {
    response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
    log.info('Tracker data fetched');
  } catch (e, stackTrace) {
    log.severe('Error in fetching tracker: $e', e, stackTrace);
    return null;
  }
  if (response.statusCode == 200) {
    print('decoded: ${jsonDecode(response.body)}');

    tracker = Tracker.fromJson(jsonDecode(response.body));
    trackerData = {
      'trackerID': trackerID,
      'name': tracker.name,
      'type': tracker.type.name,,
      'description': tracker.description,
    };

    try {
      path = '/api/v3/trackers/${config.docTrackers["Tracker"]}/items';
      // print('path: $path');
      response = await http.post(Uri.https(docServer, path),
          headers: httpHeader(), body: jsonEncode(trackerData));
      log.info('Tracker documentation data stored in documentation tracker');
    } catch (e, stackTrace) {
      log.severe('Error in fetching tracker details: $e', e, stackTrace);
      return null;
    }
  }
  return tracker.id;
}
