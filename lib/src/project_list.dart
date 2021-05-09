import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'project.dart';
import 'tracker_list.dart';
import 'configuration.dart';
import 'helper.dart';

class ProjectList extends StatefulWidget {
  ProjectList({this.projects}) : super();
  final List<Project> projects;

  @override
  ProjectListState createState() => ProjectListState();
}

class ProjectListState extends State<ProjectList> {
  Configuration config = Configuration();
  List<String> headerRow = ['ID', 'Name', 'Description', 'Project ID'];
  List<List<String>> data = [];

  String title = '';

  @override
  void initState() {
    title = 'Projects on codebeamer server "${config.baseURLs['homeServer']}"';

    widget.projects.forEach((project) {
      data.add([
        project.id.toString(),
        project.name,
        project.description,
        project.projectID.toString()
      ]);
    });
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
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Expanded(
                  flex: 10,
                  child: LazyDataTable(
                    rows: data.length,
                    columns: headerRow.length,
                    tableDimensions: LazyDataTableDimensions(
                      // customCellHeight: {1: 0, 2:150, 3:300, 4: 20},
                      customCellWidth: {0: 50, 1: 150, 2: 300, 3: 75},
                    ),
                    tableTheme: LazyDataTableTheme(
                        columnHeaderBorder: Border.all(color: Colors.orange),
                        columnHeaderColor: Colors.orange,
                        rowHeaderBorder: Border.all(color: Colors.orange),
                        rowHeaderColor: Colors.orange,
                        cornerBorder: Border.all(color: Colors.orange),
                        cornerColor: Colors.orange,
                        cellBorder: Border.all(color: Colors.orange),
                        cellColor: Colors.white,
                        alternateRow: false,
                        alternateColumn: false),
                    topHeaderBuilder: (i) => Center(child: Text(headerRow[i])),
                    // leftHeaderBuilder: (i) => Center(child: SizedBox.shrink()),
                    dataCellBuilder: (i, j) => Center(child: Text(data[i][j])),
                    // topLeftCornerWidget: Center(child: Text('Projects')),
                  ))
            ]));

    // ListView(children: projectList(context, widget.projects)));
  }
}
/*
  List<Widget> projectList(BuildContext context, List<Project> projects) {
    List<Widget> list = <Widget>[];

    projects.forEach((project) {
      Future<ProjectDetail> projectDetail = fetchProjectDetail(project.id);
      list.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          title: InkWell(
            child: Text(
              '${project.name} (${project.id})',
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
                  builder: (BuildContext context) => TrackerList(
                      context: context,
                      projectID: project.id,
                      projectName: project.name),
                ),
              );
            },
          ),
        ),
        FutureBuilder<ProjectDetail>(
          future: projectDetail,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return (Text(snapshot.error));
            } else {
              return snapshot.hasData
                  ? Text(snapshot.data.description.truncateTo(79),
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Raleway',
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ))
                  : Center(child: CircularProgressIndicator());
            }
          },
        ),
      ]));
    });
    return list;
  }
}
*/
