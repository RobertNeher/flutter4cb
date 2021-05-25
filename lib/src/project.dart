import 'dart:convert';
import 'configuration.dart';
import 'helper.dart';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  // ProjectDetail pd;
  // Project found = await lookupProjectName(int.parse(args[0]));
  // List<Project> projects = await fetchProjects();

  // print('Project "$args[0]" found: ${found != null}');
  // projects.forEach((project) async {
  //   pd = await fetchProjectDetail(project.id);
  //   print('${project.name} (${project.id}): ${pd.description}');
  // });
}

Future<Project> lookupProjectName(int projectID) async {
  Configuration config = Configuration();
  http.Response response;

  String docServer = config.baseURLs['documentationServer'];
  String path = '/api/v3/items/query';

  try {
    String query =
        'project.id in (${config.documentationProjectID}) AND tracker.id in (${config.docTrackers["Project"]}) and \'${config.docTrackers["Project"]}.customField[0]\' = \'$projectID\'';

    response = await http.get(
        Uri.https(docServer, path,
            {'page': '1', 'pageSize': '25', 'queryString': query}),
        headers: httpHeader());
  } catch (e, stackTrace) {
    return null;
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
      return null;
    }
  }
  return null;
}

Future<List<Project>> fetchProjects() async {
  List<Project> projects;
  ProjectDetail pd;
  Configuration config = Configuration();

  final response = await http.get(
      Uri.https(config.baseURLs['homeServer'], '/api/v3/projects'),
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
    return null;
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
      Uri.https(config.baseURLs['homeServer'], '/api/v3/projects/$projectID'),
      headers: httpHeader());

  if (response.statusCode == 200) {
    Map json = jsonDecode(response.body);
    return ProjectDetail.fromJson(json);
  } else {
    print("Error ${response.statusCode}");
    return null;
  }
}

class ProjectDetail {
  int id;
  String name;
  String description;
  String descriptionFormat;
  int version;
  String keyName;
  String category;
  bool closed;
  bool deleted;
  bool template;
  String createdAt;
  CreatedBy createdBy;
  String modifiedAt;
  CreatedBy modifiedBy;

  ProjectDetail(
      {this.id,
      this.name,
      this.description,
      this.descriptionFormat,
      this.version,
      this.keyName,
      this.category,
      this.closed,
      this.deleted,
      this.template,
      this.createdAt,
      this.createdBy,
      this.modifiedAt,
      this.modifiedBy});

  ProjectDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    descriptionFormat = json['descriptionFormat'];
    version = json['version'];
    keyName = json['keyName'];
    category = json['category'];
    closed = json['closed'];
    deleted = json['deleted'];
    template = json['template'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    modifiedAt = json['modifiedAt'];
    modifiedBy = json['modifiedBy'] != null
        ? new CreatedBy.fromJson(json['modifiedBy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['descriptionFormat'] = this.descriptionFormat;
    data['version'] = this.version;
    data['keyName'] = this.keyName;
    data['category'] = this.category;
    data['closed'] = this.closed;
    data['deleted'] = this.deleted;
    data['template'] = this.template;
    data['createdAt'] = this.createdAt;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    data['modifiedAt'] = this.modifiedAt;
    if (this.modifiedBy != null) {
      data['modifiedBy'] = this.modifiedBy.toJson();
    }
    return data;
  }
}

class CreatedBy {
  int id;
  String name;
  String type;

  CreatedBy({this.id, this.name, this.type});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Project {
  final int id;
  final int projectID;
  final String name;
  final String type;
  String description;

  Project({this.id, this.projectID, this.name, this.type, this.description});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        id: json['id'],
        projectID: json['projectID'],
        name: json['name'],
        type: json['type'],
        description: json['description']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['projectID'] = this.projectID;
    data['name'] = this.name;
    data['type'] = this.type;
    data['description'] = this.description;
    return data;
  }
}
