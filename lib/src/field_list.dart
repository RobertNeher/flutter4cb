import 'package:flutter/material.dart';
import 'field.dart';
import 'tableView.dart';
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
    List<List<String>> data = [];
    final List<String> headers = [
      'ID',
      'Name',
      'Description',
      'Type',
      'Field ID'
    ];
    final Map<int, double> colWidths = {0: 50, 1: 150, 2: 300, 3: 150, 4: 75};
    Future<List<Field>> fields = fetchTrackerFields(widget.trackerID);

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
              child: FutureBuilder<List<Field>>(
                  future: fields,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Center(child: Text(snapshot.error));
                    else if (snapshot.hasData) {
                      snapshot.data.forEach((field) {
                        data.add([
                          field.id.toString(),
                          field.name,
                          field.description,
                          field.type,
                          field.fieldID.toString(),
                        ]);
                      });
                      return tableView(
                          context, data, headers, colWidths, 'Field');
                    } else {
                      return Center(
                          child:
                              CircularProgressIndicator(color: Colors.orange));
                    }
                  }))
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
