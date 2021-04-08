import 'package:flutter/material.dart';
import 'tracker.dart';
import 'configuration.dart';

class TrackerList extends StatefulWidget {
  TrackerList({this.context, this.projectID, this.projectName}) : super();

  final BuildContext context;
  final int projectID;
  final String projectName;

  @override
  TrackerListState createState() => TrackerListState();
}

class TrackerListState extends State<TrackerList> {
  Configuration config = Configuration();
  String title = '';

  @override
  void initState() {
    title = 'Tracker of project ${widget.projectName}';
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Tracker>> trackers = fetchProjectTrackers(widget.projectID);

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
            child: FutureBuilder<List<Tracker>>(
                future: trackers,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListView.separated(
                          itemCount: snapshot.data.length,
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(
                              snapshot.data[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ));
                          })
                      : Center(child: CircularProgressIndicator());
                }),
          )
        ]));
  }

  Widget trackerList(BuildContext context, List<Tracker> trackers) {
    Column list = Column();

    trackers.forEach((tracker) {
      list.children.add(
        InkWell(
            child: Text(
              '${tracker.id}: ${tracker.name}',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => TrackerItemList(
              //             context: context,
              //             trackerID: tracker.id,
              //             trackerName: tracker.name)));
            }),
      );
    });
    return list;
  }
}
