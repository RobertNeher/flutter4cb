import 'dart:convert';
import 'configuration.dart';
import 'helper.dart';
import 'package:http/http.dart' as http;

Future<Project> lookupProjectName(int projectID) async {
  Configuration config = Configuration();
  http.Response response;

  String docServer = config.baseURLs['documentationServer'] as String;
  String path = '/api/v3/items/query';

  try {
    String query =
        'project.id in (${config.documentationProjectID}) AND tracker.id in (${config.docTrackers["Project"]}) and \'${config.docTrackers["Project"]}.customField[0]\' = \'$projectID\'';

    response = await http.get(
        Uri.https(docServer, path,
            {'page': '1', 'pageSize': '25', 'queryString': query}),
        headers: httpHeader());
  } catch (e, stackTrace) {
    return Project();
  }
  if (response.statusCode == 200) {
    Map<String, dynamic> result = jsonDecode(response.body);

    if (result.length == 4 && result['total'] >= 1) {
      Map<String, dynamic> item = result['items'][0];
      return Project.fromJson({
        'id': item['id'],
        'projectID': item['customFields'][0]['value'],
        'name': item['name'],
        'description': item['description'],
      });
    } else {
      return Project();
    }
  }
  return Project();
}

Future<List<Project>> fetchProjects() async {
  List<Project> projects;
  ProjectDetail pd;
  Configuration config = Configuration();

  final response = await http.get(
      Uri.https(config.baseURLs['homeServer'] as String, '/api/v3/projects'),
      headers: httpHeader());

  if (response.statusCode == 200) {
    List jsonRaw = jsonDecode(response.body);

    projects = jsonRaw.map((item) => Project.fromJson(item)).toList();

    // projects.forEach((project) async {
    //   pd = await fetchProjectDetail(project.id);
    //   project.description = pd.description ?? ' ';
    // });

    return projects;
  } else {
    print("Error ${response.statusCode}");
    return [];
  }
}

Future<List<Project>> fetchProjectsExtended() async {
  List<Project> projects = await fetchProjects();

  projects.forEach((project) async {
    ProjectDetail pd = await fetchProjectDetail(project.id);
    project.description = pd.description;
  });

  return projects;
}

Future<ProjectDetail> fetchProjectDetail(int projectID) async {
  Configuration config = Configuration();

  final response = await http.get(
      Uri.https(config.baseURLs['homeServer'] as String,
          '/api/v3/projects/$projectID'),
      headers: httpHeader());

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return ProjectDetail.fromJson(json);
  } else {
    print("Error ${response.statusCode}");
    return ProjectDetail();
  }
}

class ProjectDetail {
  int id = 0;
  String name = '';
  String description = '';
  String descriptionFormat = '';

  ProjectDetail({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.descriptionFormat = '',
  });

  ProjectDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    descriptionFormat = json['descriptionFormat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['descriptionFormat'] = this.descriptionFormat;
    return data;
  }
}

class Project {
  int id = 0;
  int projectID = 0;
  String name = '';
  String description = '';

  Project(
      {this.id = 0, this.projectID = 0, this.name = '', this.description = ''});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        id: json['id'],
        projectID: json['projectID'],
        name: json['name'],
        description: json['description']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['projectID'] = this.projectID;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
