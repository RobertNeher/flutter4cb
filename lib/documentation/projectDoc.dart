import 'package:http/http.dart' as http;
import 'dart:convert';
import '../src/configuration.dart';
import '../src/helper.dart';
import 'package:logging/logging.dart';

import '../src/project.dart';

void main(List<String> args) async {
  int result = await documentProject(int.parse(args[0]));
  print('...and the winner is $result');
}

Future<int> documentProject(int projectID) async {
  final log = Logger('ProjectDoc');

  Project project;
  ProjectDetail projDetail;
  Configuration config = Configuration();

  String homeServer = config.baseURLs['homeServer'];
  String docServer = config.baseURLs['documentationServer'];
  String path = '/api/v3/projects/$projectID';
  http.Response response;
  Map<String, dynamic> projectData;

  try {
    response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
    log.info('Project data fetched');
  } catch (e, stackTrace) {
    log.severe('Error in fetching project details: $e', e, stackTrace);
    return null;
  }
  if (response.statusCode == 200) {
    project = Project.fromJson(jsonDecode(response.body));
    projDetail = await fetchProjectDetail(project.id);
    // print('get project: ${project.name}');
    // print('get project detail: ${projDetail.name}');
    log.info('Project detail fetched');
    projectData = {
      'id': project.id,
      'projectID': projectID,
      'name': project.name,
      'description': projDetail.description,
    };

    try {
      path = '/api/v3/trackers/${config.docTrackers["Project"]}/items';
      // print('path: $path');
      response =
          await http.post(Uri.https(docServer, path), headers: httpHeader(), body: jsonEncode(projectData));
      log.info('Project documentation data stored in documentation tracker');
    } catch (e, stackTrace) {
      log.severe('Error in fetching project details: $e', e, stackTrace);
      return -1;
    }
  }
  return project.projectID;
}