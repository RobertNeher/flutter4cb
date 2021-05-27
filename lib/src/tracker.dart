import 'dart:convert';

import 'helper.dart';
import 'configuration.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  List<Tracker> trackers = await fetchProjectTrackers(int.parse(args[0]));

  trackers.forEach((tracker) async {
    Tracker result = await lookupTrackerName(tracker.name);
    print('${tracker.name}: ${result != null}');
  });
}

Future<List<Tracker>> fetchProjectTrackers(int projectID) async {
  Configuration config = Configuration();
  List<Tracker> trackers = <Tracker>[];
  String homeServer = config.baseURLs['homeServer'] as String;
  String path = '/api/v3/projects/$projectID/trackers';

  try {
    final response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
    if (response.statusCode == 200) {
      List trackerList = jsonDecode(response.body);

      trackers = trackerList.map((item) => Tracker.fromJson(item)).toList();
    } else
      print("Error in retrieving project's trackers: ${response.statusCode}");
  } catch (e) {
    print('Error: $e');
  }
  return trackers;
}

Future<Tracker> lookupTrackerName(String name) async {
  Configuration config = Configuration();
  http.Response response;

  String docServer = config.baseURLs['documentationServer'] as String;
  String path = '/api/v3/items/query';

  try {
    response = await http.get(
        Uri.https(docServer, path, {
          'page': '1',
          'pageSize': '25',
          'queryString':
              'tracker.id in (${config.docTrackers["Tracker"]}) AND summary=\'$name\'',
        }),
        headers: httpHeader());
  } catch (e, stackTrace) {
    return Tracker();
  }
  if (response.statusCode == 200) {
    Map<String, dynamic> result = jsonDecode(response.body);

    if (result.length == 4 && result['total'] >= 1) {
      Tracker value = Tracker.fromJson(result['items'][0]);
      value.trackerID = result['items'][0]['customFields'][0]['value'];
      return value;
    } else {
      return Tracker();
    }
  }
  return Tracker();
}

class Tracker {
  int id = 0;
  int trackerID = 0;
  String name = '';
  // String type = ';
  String description = '';

  Tracker(
      {this.id = 0, this.trackerID = 0, this.name = '', this.description = ''});

  Tracker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackerID = json['trackerID'];
    name = json['name'];
    // type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['trackerID'] = this.trackerID;
    data['name'] = this.name;
    // data['type'] = this.type;
    data['description'] = this.description;
    return data;
  }
}

class TrackerDetail {
  int id = 0;
  String name = '';
  String description = '';
  String descriptionFormat = '';
  String createdAt = '';
  String createdBy = '';
  String modifiedAt = '';
  String modifiedBy = '';
  String parent = '';
  int version = 0;
  String assignedAt = '';
  String startDate = '';
  String endDate = '';
  String closedAt = '';
  int storyPoints = 0;
  String tracker = '';
  String priority = '';
  int accruedMillis = 0;
  int estimatedMillis = 0;
  int spentMillis = 0;
  String status = '';
  String typeName = '';
  // List<Comments> comments;

  TrackerDetail({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.descriptionFormat = '',
    this.createdAt = '',
    this.createdBy = '',
    this.modifiedAt = '',
    this.modifiedBy = '',
    this.parent = '',
    this.version = 0,
    this.assignedAt = '',
    this.startDate = '',
    this.endDate = '',
    this.closedAt = '',
    this.storyPoints = 0,
    this.tracker = '',
    this.priority = '',
    this.accruedMillis = 0,
    this.estimatedMillis = 0,
    this.spentMillis = 0,
    this.status = '',
    this.typeName = '',
    // this.comments
  });

  TrackerDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    descriptionFormat = json['descriptionFormat'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    modifiedAt = json['modifiedAt'];
    modifiedBy = json['modifiedBy'];
    parent = json['parent'] = json['parent'];
    version = json['version'];
    assignedAt = json['assignedAt'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    closedAt = json['closedAt'];
    storyPoints = json['storyPoints'];
    tracker = json['tracker'] = json['tracker'];
    priority = json['priority'] = json['priority'];
    accruedMillis = json['accruedMillis'];
    estimatedMillis = json['estimatedMillis'];
    spentMillis = json['spentMillis'];
    status = json['status'];
    typeName = json['typeName'];
    // if (json['comments'] != null) {
    //   comments = new List<Comments>();
    //   json['comments'].forEach((v) {
    //     comments.add(new Comments.fromJson(v));
    //   });
    // }
  }

  TrackerDetail.toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['descriptionFormat'] = this.descriptionFormat;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['modifiedAt'] = this.modifiedAt;
    data['modifiedBy'] = this.modifiedBy;
    data['parent'] = this.parent;
    data['version'] = this.version;
    data['assignedAt'] = this.assignedAt;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['closedAt'] = this.closedAt;
    data['storyPoints'] = this.storyPoints;
    data['tracker'] = this.tracker;
    data['accruedMillis'] = this.accruedMillis;
    data['estimatedMillis'] = this.estimatedMillis;
    data['spentMillis'] = this.spentMillis;
    data['status'] = this.status;
    data['typeName'] = this.typeName;
    // if (this.comments != null) {
    //   data['comments'] = this.comments.map((v) => v.toJson()).toList();
    // }
  }
}

// class CreatedBy {
//   int id;
//   String name;
//   String type;

//   CreatedBy({this.id = 0, this.name = '', this.type = ''});

//   CreatedBy.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['type'] = this.type;
//     return data;
//   }
// }

// class CustomFields {
//   int fieldId;
//   String type;
//   String name;

//   CustomFields({this.fieldId = 0, this.type = '', this.name = ''});

//   CustomFields.fromJson(Map<String, dynamic> json) {
//     fieldId = json['fieldId'];
//     type = json['type'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fieldId'] = this.fieldId;
//     data['type'] = this.type;
//     data['name'] = this.name;
//     return data;
//   }
// }
