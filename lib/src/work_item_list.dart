import 'package:flutter/material.dart';
import 'package:flutter4cb/src/tableView.dart';
import 'work_item.dart';
import 'configuration.dart';

class WorkItemList extends StatefulWidget {
  WorkItemList({this.context, this.trackerID, this.trackerName}) : super();

  final BuildContext context;
  final int trackerID;
  final String trackerName;

  @override
  WorkItemListState createState() => WorkItemListState();
}

class WorkItemListState extends State<WorkItemList> {
  Configuration config = Configuration();
  String title = '';

  @override
  void initState() {
    title = 'Work items of tracker ${widget.trackerName} (${widget.trackerID})';
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> data = [];
    final List<String> headers = [
      'ID',
      'Name',
      'Description',
      'Type',
    ];
    final Map<int, double> colWidths = {0: 50, 1: 150, 2: 300, 3: 150};

    Future<List<WorkItemPage>> pages = fetchWorkItemPages(widget.trackerID);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: FutureBuilder<List<WorkItemPage>>(
                  future: pages,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Center(child: Text(snapshot.error));
                    else if (snapshot.hasData) {
                      snapshot.data.forEach((page) {
                        page.workItems.forEach((workItem) {
                          data.add([
                            workItem.id.toString(),
                            workItem.name,
                            workItem.description,
                            workItem.type,
                          ]);
                        });
                      });
                      return tableView(
                          context, data, headers, colWidths, 'WorkItem');
                    } else {
                      return Center(
                          child:
                              CircularProgressIndicator(color: Colors.orange));
                    }
                  }))
        ]));
  }
}

List<Widget> workItemsList(BuildContext context, List<WorkItemPage> pages) {
  List<ListTile> listTiles = <ListTile>[];

  pages.forEach((page) {
    page.workItems.forEach((workItem) {
      listTiles.add(
        ListTile(
            title: Text(
              '${workItem.name} (${workItem.id})',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            onTap: () {}),
      );
    });
  });
  return listTiles;
}
