import 'package:http/http.dart' as http;
import 'dart:convert';
import '../src/configuration.dart';
import '../src/helper.dart';

import '../src/project.dart';

void main(List<String> args) async {
  Project result = await documentProject(int.parse(args[0]));
  print('...and the winner is ${result.name}');
}

Future<Project> documentProject(int projectID) async {
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
  } catch (e, stackTrace) {
    print('Error in fetching project details: $e: $stackTrace');
    return null;
  }
  if (response.statusCode != 200) {
    print('Error in fetching project details');
    return null;
  }
  project = Project.fromJson(jsonDecode(response.body));
  projDetail = await fetchProjectDetail(project.id);

  projectData = {
    'customFields': [
      {
        'fieldId': 10000,
        'name': 'projectID',
        'title': 'Project ID',
        'type': 'IntegerFieldValue',
        'value': projectID,
      }
    ],
    'name': project.name,
    'description': projDetail.description,
  };

  try {
    path = '/api/v3/trackers/${config.docTrackers["Project"]}/items';

    response = await http.post(Uri.https(docServer, path),
        headers: httpHeader(), body: jsonEncode(projectData));
  } catch (e, stackTrace) {
    print('Error in posting project data: $e: $stackTrace');
    return null;
  }
  if (response.statusCode != 200) {
    print('Project not posted: ${response.statusCode}');
    return null;
  }
  return lookupProjectName(projectID);
}
