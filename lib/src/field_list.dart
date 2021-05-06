import 'package:flutter/material.dart';
import 'field.dart';
import 'work_item_list.dart';
import 'configuration.dart';

class FieldList extends StatefulWidget {
  FieldList({this.context, this.trackerID, this.trackerName}) : super();

  final BuildContext context;
  final int trackerID;
  final String trackerName;

  @override
  FieldListState createState() => FieldListState();
}

class FieldListState extends State<FieldList> {
  Configuration config = Configuration();
  String title = '';

  @override
  void initState() {
    title = 'Fields of tracker ${widget.trackerName} (${widget.trackerID})';
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Field>> fields = fetchTrackerFields(widget.trackerID);

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
            child: FutureBuilder<List<Field>>(
                future: fields,
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
                                  '${snapshot.data[index].name} (${snapshot.data[index].id})',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (BuildContext context) =>
                                  //           fieldList(context, snapshot.data)),
                                  // );
                                });
                          })
                      : Center(child: CircularProgressIndicator());
                }),
          )
        ]));
  }

  Widget fieldList(BuildContext context, List<Field> fields) {
    Column list = Column();

    fields.forEach((field) {
      list.children.add(
        InkWell(
          child: Text(
            '${field.name} (${field.id}): ${field.type}',
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
