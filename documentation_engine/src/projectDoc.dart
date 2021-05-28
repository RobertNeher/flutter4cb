import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../lib/src/configuration.dart';
import '../../lib/src/helper.dart';

import '../../lib/src/project.dart';

Future<Project> documentProject(int projectID) async {
  Project project;
  ProjectDetail projDetail;
  Configuration config = Configuration();

  String homeServer = config.baseURLs['homeServer'] as String;
  String docServer = config.baseURLs['documentationServer'] as String;
  String path = '/api/v3/projects/$projectID';
  http.Response response;
  Map<String, dynamic> projectData;

  try {
    response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
  } catch (e, stackTrace) {
    print('Error in fetching project details: $e: $stackTrace');
    return Project();
  }
  if (response.statusCode != 200) {
    print('Error in fetching project details');
    return Project();
  }
  projectData = jsonDecode(response.body);
  projectData.putIfAbsent('projectID', () => 0);
  project = Project.fromJson(projectData);
  print(project);
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
    return Project();
  }
  if (response.statusCode != 200) {
    print('Project not posted: ${response.statusCode}');
    return Project();
  }
  return lookupProjectName(projectID);
}
