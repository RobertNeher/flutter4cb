import 'package:flutter/material.dart';
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
    title = 'Work items of tracker ${widget.trackerName} (${widget.trackerID}';
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<WorkItems>> workItems = fetchWorkItems(widget.trackerID);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: FutureBuilder<List<WorkItems>>(
                future: workItems,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListView(
                          children: workItemsList(context, snapshot.data))
                      : Center(child: CircularProgressIndicator());
                }),
          )
        ]));
  }
}

List<Widget> workItemsList(BuildContext context, List<WorkItems> workItems) {
  List<ListTile> listTiles = <ListTile>[];

  workItems.forEach((page) {
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
