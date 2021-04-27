import 'dart:convert';
import 'package:flutter4cb/src/helper.dart';
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
  List<Tracker> trackers;
  String homeServer = config.baseURLs['homeServer'];
  String path = '/api/v3/projects/$projectID/trackers';

  try {
    final response =
        await http.get(Uri.https(homeServer, path), headers: httpHeader());
    if (response.statusCode == 200) {
      List trackerList = jsonDecode(response.body);

      trackers = trackerList.map((item) => Tracker.fromJson(item)).toList();
    } else
      print("Error ${response.statusCode}");
  } catch (e) {
    print('Error: $e');
  }
  return trackers;
}

Future<Tracker> lookupTrackerName(String name) async {
  Configuration config = Configuration();
  http.Response response;

  String docServer = config.baseURLs['documentationServer'];
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
    return null;
  }
  if (response.statusCode == 200) {
    print(response.body);
    Map<String, dynamic> result = jsonDecode(response.body);

    if (result.length == 4 && result['total'] >= 1) {
      return Tracker.fromJson(result['items'][0]);
    } else {
      return null;
    }
  }
  return null;
}

class Tracker {
  int id;
  int trackerID;
  String name;
  // String type;
  String description;

  Tracker({this.id, this.trackerID, this.name, this.description});

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
  int id;
  String name;
  String description;
  String descriptionFormat;
  String createdAt;
  CreatedBy createdBy;
  String modifiedAt;
  CreatedBy modifiedBy;
  CreatedBy parent;
  // List<Owners> owners;
  int version;
  String assignedAt;
  // List<AssignedTo> assignedTo;
  String startDate;
  String endDate;
  String closedAt;
  int storyPoints;
  CreatedBy tracker;
  // List<Children> children;
  List<CustomFields> customFields;
  CreatedBy priority;
  int accruedMillis;
  int estimatedMillis;
  int spentMillis;
  CreatedBy status;
  // List<Platforms> platforms;
  // List<Categories> categories;
  // List<Subjects> subjects;
  // List<Resolutions> resolutions;
  // List<Severities> severities;
  CreatedBy releaseMethod;
  // List<Teams> teams;
  // List<Areas> areas;
  // List<Versions> versions;
  int ordinal;
  String typeName;
  // List<Comments> comments;

  TrackerDetail({
    this.id,
    this.name,
    this.description,
    this.descriptionFormat,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.parent,
    // this.owners,
    this.version,
    this.assignedAt,
    // this.assignedTo,
    this.startDate,
    this.endDate,
    this.closedAt,
    this.storyPoints,
    this.tracker,
    // this.children,
    this.customFields,
    this.priority,
    this.accruedMillis,
    this.estimatedMillis,
    this.spentMillis,
    this.status,
    // this.platforms,
    // this.categories,
    // this.subjects,
    // this.resolutions,
    // this.severities,
    this.releaseMethod,
    // this.teams,
    // this.areas,
    // this.versions,
    this.ordinal,
    this.typeName,
    // this.comments
  });

  TrackerDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    descriptionFormat = json['descriptionFormat'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    modifiedAt = json['modifiedAt'];
    modifiedBy = json['modifiedBy'] != null
        ? new CreatedBy.fromJson(json['modifiedBy'])
        : null;
    parent =
        json['parent'] != null ? new CreatedBy.fromJson(json['parent']) : null;
    // if (json['owners'] != null) {
    //   owners = [];
    //   json['owners'].forEach((v) {
    //     owners.add(new Owners.fromJson(v));
    //   });
    // }
    version = json['version'];
    assignedAt = json['assignedAt'];
    // if (json['assignedTo'] != null) {
    //   assignedTo = [];
    //   json['assignedTo'].forEach((v) {
    //     assignedTo.add(new AssignedTo.fromJson(v));
    //   });
    // }
    startDate = json['startDate'];
    endDate = json['endDate'];
    closedAt = json['closedAt'];
    storyPoints = json['storyPoints'];
    tracker = json['tracker'] != null
        ? new CreatedBy.fromJson(json['tracker'])
        : null;
    // if (json['children'] != null) {
    //   children = new List<Children>();
    //   json['children'].forEach((v) {
    //     children.add(new Children.fromJson(v));
    //   });
    // }
    if (json['customFields'] != null) {
      customFields = <CustomFields>[];
      json['customFields'].forEach((v) {
        customFields.add(new CustomFields.fromJson(v));
      });
    }
    priority = json['priority'] != null
        ? new CreatedBy.fromJson(json['priority'])
        : null;
    accruedMillis = json['accruedMillis'];
    estimatedMillis = json['estimatedMillis'];
    spentMillis = json['spentMillis'];
    status =
        json['status'] != null ? new CreatedBy.fromJson(json['status']) : null;
    // if (json['platforms'] != null) {
    //   platforms = new List<Platforms>();
    //   json['platforms'].forEach((v) {
    //     platforms.add(new Platforms.fromJson(v));
    //   });
    // }
    // if (json['categories'] != null) {
    //   categories = new List<Categories>();
    //   json['categories'].forEach((v) {
    //     categories.add(new Categories.fromJson(v));
    //   });
    // }
    // if (json['subjects'] != null) {
    //   subjects = new List<Subjects>();
    //   json['subjects'].forEach((v) {
    //     subjects.add(new Subjects.fromJson(v));
    //   });
    // }
    // if (json['resolutions'] != null) {
    //   resolutions = new List<Resolutions>();
    //   json['resolutions'].forEach((v) {
    //     resolutions.add(new Resolutions.fromJson(v));
    //   });
    // }
    // if (json['severities'] != null) {
    //   severities = new List<Severities>();
    //   json['severities'].forEach((v) {
    //     severities.add(new Severities.fromJson(v));
    //   });
    // }
    releaseMethod = json['releaseMethod'] != null
        ? new CreatedBy.fromJson(json['releaseMethod'])
        : null;
    // if (json['teams'] != null) {
    //   teams = new List<Teams>();
    //   json['teams'].forEach((v) {
    //     teams.add(new Teams.fromJson(v));
    //   });
    // }
    // if (json['areas'] != null) {
    //   areas = new List<Areas>();
    //   json['areas'].forEach((v) {
    //     areas.add(new Areas.fromJson(v));
    //   });
    // }
    // if (json['versions'] != null) {
    //   versions = new List<Versions>();
    //   json['versions'].forEach((v) {
    //     versions.add(new Versions.fromJson(v));
    //   });
    // }
    ordinal = json['ordinal'];
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
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    data['modifiedAt'] = this.modifiedAt;
    if (this.modifiedBy != null) {
      data['modifiedBy'] = this.modifiedBy.toJson();
    }
    if (this.parent != null) {
      data['parent'] = this.parent.toJson();
    }
    // if (this.owners != null) {
    //   data['owners'] = this.owners.map((v) => v.toJson()).toList();
    // }
    data['version'] = this.version;
    data['assignedAt'] = this.assignedAt;
    // if (this.assignedTo != null) {
    //   data['assignedTo'] = this.assignedTo.map((v) => v.toJson()).toList();
    // }
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['closedAt'] = this.closedAt;
    data['storyPoints'] = this.storyPoints;
    if (this.tracker != null) {
      data['tracker'] = this.tracker.toJson();
    }
    // if (this.children != null) {
    //   data['children'] = this.children.map((v) => v.toJson()).toList();
    // }
    if (this.customFields != null) {
      data['customFields'] = this.customFields.map((v) => v.toJson()).toList();
    }
    if (this.priority != null) {
      data['priority'] = this.priority.toJson();
    }
    data['accruedMillis'] = this.accruedMillis;
    data['estimatedMillis'] = this.estimatedMillis;
    data['spentMillis'] = this.spentMillis;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    // if (this.platforms != null) {
    //   data['platforms'] = this.platforms.map((v) => v.toJson()).toList();
    // }
    // if (this.categories != null) {
    //   data['categories'] = this.categories.map((v) => v.toJson()).toList();
    // }
    // if (this.subjects != null) {
    //   data['subjects'] = this.subjects.map((v) => v.toJson()).toList();
    // }
    // if (this.resolutions != null) {
    //   data['resolutions'] = this.resolutions.map((v) => v.toJson()).toList();
    // }
    // if (this.severities != null) {
    //   data['severities'] = this.severities.map((v) => v.toJson()).toList();
    // }
    if (this.releaseMethod != null) {
      data['releaseMethod'] = this.releaseMethod.toJson();
    }
    // if (this.teams != null) {
    //   data['teams'] = this.teams.map((v) => v.toJson()).toList();
    // }
    // if (this.areas != null) {
    //   data['areas'] = this.areas.map((v) => v.toJson()).toList();
    // }
    // if (this.versions != null) {
    //   data['versions'] = this.versions.map((v) => v.toJson()).toList();
    // }
    data['ordinal'] = this.ordinal;
    data['typeName'] = this.typeName;
    // if (this.comments != null) {
    //   data['comments'] = this.comments.map((v) => v.toJson()).toList();
    // }
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

class CustomFields {
  int fieldId;
  String type;
  String name;

  CustomFields({this.fieldId, this.type, this.name});

  CustomFields.fromJson(Map<String, dynamic> json) {
    fieldId = json['fieldId'];
    type = json['type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldId'] = this.fieldId;
    data['type'] = this.type;
    data['name'] = this.name;
    return data;
  }
}
