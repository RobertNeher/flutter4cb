import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'project.dart';
import 'configuration.dart';
import 'helper.dart';
class ProjectZIP {
  String password;
  bool skipTrackerItems;
  bool skipWikiPages;
  bool skipAssociations;
  bool skipDocuments;
  bool skipReports;
  bool skipBranches;
  List<int> selectedTrackerIds;

  ProjectZIP(
      {this.password,
      this.skipTrackerItems,
      this.skipWikiPages,
      this.skipAssociations,
      this.skipDocuments,
      this.skipReports,
      this.skipBranches,
      this.selectedTrackerIds});

  ProjectZIP.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    skipTrackerItems = json['skipTrackerItems'];
    skipWikiPages = json['skipWikiPages'];
    skipAssociations = json['skipAssociations'];
    skipDocuments = json['skipDocuments'];
    skipReports = json['skipReports'];
    skipBranches = json['skipBranches'];
    selectedTrackerIds = json['selectedTrackerIds'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['skipTrackerItems'] = this.skipTrackerItems;
    data['skipWikiPages'] = this.skipWikiPages;
    data['skipAssociations'] = this.skipAssociations;
    data['skipDocuments'] = this.skipDocuments;
    data['skipReports'] = this.skipReports;
    data['skipBranches'] = this.skipBranches;
    data['selectedTrackerIds'] = this.selectedTrackerIds;
    return data;
  }
}

Future<ProjectDetail> export(int projectID) async {
  Configuration config = Configuration();

  final response =
      await http.get(
      Uri.https(config.RESTBase, '/projects/$projectID'),
      headers: httpHeader());

  if (response.statusCode == 200) {
    Map json = jsonDecode(response.body);
    return ProjectDetail.fromJson(json);
  } else {
    print("Error ${response.statusCode}");
    return null;
  }
}
