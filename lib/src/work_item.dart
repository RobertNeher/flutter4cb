import 'dart:convert';
import 'package:flutter4cb/src/helper.dart';

import 'configuration.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  var workItems = await fetchWorkItems(int.parse(args[0]));
  workItems.forEach((page) {
    print('${page.page} (${page.pageSize}/${page.total}:');
    page.workItems.forEach((workItem) {
      print('${workItem.name} (${workItem.id})');
    });
  });
}

Future<List<WorkItems>> fetchWorkItems(int trackerID) async {
  Configuration config = Configuration();

  int pageNr = 0;
  final maxPageSize = 500;

  while (true) {
    pageNr++;

    var response = await http.get(
        Uri.https(config.baseURLs['homeServer'], '/api/v3/trackers/$trackerID/items',
            {'page': pageNr, 'pageSize': maxPageSize}),
        headers: httpHeader());

    if (response.statusCode == 200) {
      return (jsonDecode(response.body));
    } else
      print("Error ${response.statusCode}");
    return null;
  }
}

class WorkItem {
  int id;
  String name;
  String type;

  WorkItem({this.id, this.name, this.type});

  factory WorkItem.fromJson(Map<String, dynamic> json) {
    return WorkItem(id: json['id'], name: json['name'], type: json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class WorkItems {
  int page;
  int pageSize;
  int total;

  List<WorkItem> workItems = <WorkItem>[];

  WorkItems({this.page, this.pageSize, this.total, this.workItems});

  WorkItems.fromJson(Map<String, dynamic> json) {
    this.page = json['page'] as int;
    this.pageSize = json['pageSize'] as int;
    this.total = json['total'] as int;
    // print(this.page);
    // print(this.pageSize);
    // print(this.total);

    if (json['itemRefs'] != null) {
      this.workItems = <WorkItem>[];
      json['itemRefs'].forEach((workItem) {
        workItems.add(new WorkItem.fromJson(workItem));
      });
      // print(workItems);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['total'] = this.total;

    if (this.workItems != null) {
      data['itemRefs'] =
          this.workItems.map((workItem) => workItem.toJson()).toList();
    }

    return data;
  }
}
