import 'package:flutter/material.dart';
import 'package:flutter4cb/src/field_list.dart';
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
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListView.separated(
                          itemCount: snapshot.data.length,
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemBuilder: (context, index) {
                            if (isSelected[0]) {
                              return ListTile(
                                  title: Text(
                                    '${snapshot.data[index].name} (${snapshot.data[index].id})',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Raleway',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                WorkItemList(
                                                    context: context,
                                                    trackerID:
                                                        snapshot.data[index].id,
                                                    trackerName: snapshot
                                                        .data[index].name)));
                                  });
                            } else if (isSelected[1])
                              return ListTile(
                                  title: Text(
                                    '${snapshot.data[index].name} (${snapshot.data[index].id})',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Raleway',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FieldList(
                                                    context: context,
                                                    trackerID:
                                                        snapshot.data[index].id,
                                                    trackerName: snapshot
                                                        .data[index].name)));
                                  });
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
            '${tracker.name} (${tracker.id})',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Raleway',
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
    return list;
  }
}
