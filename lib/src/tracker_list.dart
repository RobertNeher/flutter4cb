import 'package:flutter/material.dart';
import 'configuration.dart';
import 'tracker.dart';

class TrackerList extends StatefulWidget {
  TrackerList({this.context, this.projectID, this.projectName, this.trackers})
      : super();

  final BuildContext context;
  final int projectID;
  final List<Tracker> trackers;
  final String projectName;

  @override
  TrackerListState createState() => TrackerListState();
}

class TrackerListState extends State<TrackerList> {
  Configuration config = Configuration();
  String title = '';

  @override
  void initState() {
    title = 'Trackers of project ${widget.projectName})';
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
                color: Colors.orange,
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: trackerList(context, widget.projectID),
        ));
  }

  List<Widget> trackerList(BuildContext context, int projectID) {
    Future<List<Tracker>> trackerList = fetchProjectTrackers(projectID);
    List<Widget> list = <Widget>[];

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 10.0,
          ),
          // FutureBuilder<List<Tracker>>(
          //     future: trackerList,
          //     builder: (context, snapshot) {
          //       if (snapshot.hasError) print(snapshot.error);
          //       return snapshot.hasData
          //           ? listTrackers(context, snapshot.data)
          //           : Center(child: CircularProgressIndicator());
          //   }
        ]),
      );
    }
  }

  Widget listTrackers(BuildContext context, List<Tracker> trackers) {
    List<Widget> itemList = <Widget>[];

    trackers.forEach((tracker) {
      print(tracker.name);
      itemList.add(Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              child: Text(
                '${tracker.id}: ${tracker.name}',
                style: TextStyle(
                  color: Colors.orange,
                  fontFamily: 'Raleway',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                print('Clicked on ${tracker.id}');
              },
            ),
            // FutureBuilder<ProjectDetail>(
            //     future: projectDetail,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError) print(snapshot.error);
            //       return snapshot.hasData
            //           ? ProjectInfo(context, snapshot.data)
            //           : Center(child: CircularProgressIndicator());
            //     }),
          ]));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: itemList,
    );
  }
}
