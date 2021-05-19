import 'package:flutter/material.dart';
import 'tableView.dart';
import 'tracker.dart';
import 'field_list.dart';
import 'work_item_list.dart';
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
  List<bool> isSelected = [false, false]; //Field list otherwise

  @override
  void initState() {
    title = 'Tracker of project ${widget.projectName} (${widget.projectID})';
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> data = [];
    final Map<int, double> colWidths = {0: 50, 1: 150, 2: 300, 3: 75};
    final List<String> header = ['ID', 'Name', 'Description', 'Tracker ID'];
    Future<List<Tracker>> trackers = fetchProjectTrackers(widget.projectID);

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ToggleButtons(
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.work),
                      Text('Work Items', style: TextStyle(fontSize: 10.0))
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.settings_applications),
                      Text('Fields', style: TextStyle(fontSize: 10.0))
                    ]),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
            ),
            Expanded(
                child: FutureBuilder<List<Tracker>>(
                    future: trackers,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error);
                      }
                      if (snapshot.hasData) {
                        snapshot.data.forEach((tracker) {
                          data.add([
                            tracker.id.toString(),
                            tracker.name,
                            tracker.description,
                            tracker.trackerID.toString()
                          ]);
                        });
                        return tableView(
                            context, data, header, colWidths, 'Tracker');
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                                color: Colors.orange));
                      }
                    }))
          ],
        ));
  }
}
