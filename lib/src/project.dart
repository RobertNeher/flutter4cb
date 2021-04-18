import 'dart:convert';
import 'dart:io';
import 'configuration.dart';
import 'helper.dart';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  ProjectDetail pd;

  await fetchProjects().then((value) => value.forEach((element) async {
        await fetchProjectDetail(element.id).then((detail) => pd = detail);
        print('${element.name}: ${pd.description}');

      }));
  return pd;
}

Future<List<Project>> fetchProjects() async {
  List<Project> projects;
  Configuration config = Configuration();

  final response = await http.get(Uri.http(config.RESTBase, '/api/v3/projects'),
      headers: httpHeader());

  if (response.statusCode == 200) {
    List jsonRaw = jsonDecode(response.body);

    projects = jsonRaw.map((item) => Project.fromJson(item)).toList();
  } else
    print("Error ${response.statusCode}");

  return projects;
}

Future<ProjectDetail> fetchProjectDetail(int projectID) async {
  Configuration config = Configuration();

  final response = await http.get(
      Uri.http(config.RESTBase, '/api/v3/projects/$projectID'),
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
  final String name;
  final String type;

  Project({this.id, this.name, this.type});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}
