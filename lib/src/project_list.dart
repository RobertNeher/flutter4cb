import 'package:flutter/material.dart';
import 'project.dart';
import 'tracker_list.dart';
import 'configuration.dart';

class ProjectList extends StatefulWidget {
  ProjectList({this.projects}) : super();

  final List<Project> projects;

  @override
  ProjectListState createState() => ProjectListState();
}

class ProjectListState extends State<ProjectList> {
  Configuration config = Configuration();
  String title = '';

  @override
  void initState() {
    title = 'Projects on codeBeamer server (${config.RESTBaseURL})';
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
                color: Colors.white,
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: projectList(context, widget.projects),
        ));
  }

  List<Widget> projectList(BuildContext context, List<Project> projects) {
    List<Widget> list = <Widget>[];

    projects.forEach((project) {
      Future<ProjectDetail> projectDetail = fetchProjectDetail(project.id);

      list.add(Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: 10.0,
        ),
        InkWell(
          child: Text(
            '${project.id}: ${project.name}',
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
                        projectName: project.name)));
          },
        ),
        FutureBuilder<ProjectDetail>(
          future: projectDetail,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? Text(snapshot.data.description,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Raleway',
                      fontSize: 10.0,
                      fontWeight: FontWeight.normal,
                    ))
                : Center(child: CircularProgressIndicator());
          },
        ),
      ]));
    });
    return list;
  }
}
