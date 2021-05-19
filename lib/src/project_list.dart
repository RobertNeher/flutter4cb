import 'package:flutter/material.dart';
import 'project.dart';
import 'tracker_list.dart';
import 'configuration.dart';
import 'tableView.dart';

class ProjectList extends StatefulWidget {
  ProjectList({this.projects}) : super();
  final List<Project> projects;

  @override
  ProjectListState createState() => ProjectListState();
}

class ProjectListState extends State<ProjectList> {
  Configuration config = Configuration();
  List<List<String>> data = [];
  ProjectDetail pd;

  String title = '';

  @override
  void initState() {
    title = 'Projects on codebeamer server "${config.baseURLs['homeServer']}"';

    widget.projects.forEach((project) async {
      pd = await fetchProjectDetail(project.id);
      data.add([
        project.id.toString(),
        project.name,
        pd.description,
        // project.projectID;
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
    Future<List<Project>> projects = fetchProjects();
    final List<String> header = ['ID', 'Name', 'Description', 'Project ID'];
    final Map<int, double> colWidth = {0: 50, 1: 150, 2: 300, 3: 75};

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
                  child: Center(
                      child: FutureBuilder<List<Project>>(
                          future: projects,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error);
                            } else if (snapshot.hasData) {
                              return tableView(
                                  context, data, header, colWidth, 'Project');
                            } else
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Colors.orange,
                              ));
                          })))
            ]));
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
