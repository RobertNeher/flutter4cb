import 'dart:convert';
import 'package:flutter4cb/src/helper.dart';

import 'configuration.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  int trackerID = int.parse(args[0]);
  List<WorkItemPage> workItemPages = await fetchWorkItemPages(trackerID);
  print(workItemPages.length);
  workItemPages.forEach((page) {
    print('${page.page} (${page.pageSize}/${page.total}:');
    page.workItems.forEach((workItem) {
      print('${workItem.name} (${workItem.id})');
    });
  });
}

Future<List<WorkItemPage>> fetchWorkItemPages(int trackerID) async {
  Configuration config = Configuration();
  List<WorkItemPage> pages = <WorkItemPage>[];
  WorkItemPage stats;

  final int maxPageSize = 500;
  int maxPages;

  var response = await http.get(
      Uri.https(
          config.baseURLs['homeServer'],
          '/api/v3/trackers/$trackerID/items',
          {'page': '1', 'pageSize': maxPageSize.toString()}),
      headers: httpHeader());

  if (response.statusCode == 200) {
    stats = WorkItemPage.fromJson(jsonDecode(response.body));
    maxPages = (stats.total / maxPageSize).round();
  } else {
    return null;
  }
  for (int pageNr = 1; pageNr < maxPages; pageNr++) {
    response = await http.get(
        Uri.https(
            config.baseURLs['homeServer'],
            '/api/v3/trackers/$trackerID/items',
            {'page': pageNr.toString(), 'pageSize': maxPageSize.toString()}),
        headers: httpHeader());

    if (response.statusCode == 200) {
      WorkItemPage pageItem = WorkItemPage.fromJson(jsonDecode(response.body));
      pages.add(pageItem);
    } else {
      print("Error ${response.statusCode}");
      return null;
    }
  }
  return pages;
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

class WorkItemPage {
  int page;
  int pageSize;
  int total;
  List<WorkItem> workItems = <WorkItem>[];

  WorkItemPage({this.page, this.pageSize, this.total, this.workItems});

  WorkItemPage.fromJson(Map<String, dynamic> json) {
    this.page = json['page'] as int;
    this.pageSize = json['pageSize'] as int;
    this.total = json['total'] as int;

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
