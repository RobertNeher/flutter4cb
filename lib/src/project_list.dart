import 'package:flutter/material.dart';
import 'package:flutter4cb/src/tracker.dart';
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
                color: Colors.orange,
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: projectList(widget.projects),
        ));
  }

  List<Widget> projectList(List<Project> projects) {
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
              color: Colors.orange,
              fontFamily: 'Raleway',
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (BuildContext context) {
            //   TrackerList(context, project.name);
          },
        ),
        FutureBuilder<ProjectDetail>(
            future: projectDetail,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? projectInfo(context, snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }),
      ]));
    });
    return list;
  }

  Widget projectInfo(BuildContext context, ProjectDetail projectDetail) {
    Future<List<Tracker>> trackers = fetchProjectTrackers(projectDetail.id);

    return Column(children: <Widget>[
      // FutureBuilder<List<Tracker>>(
      //     future: trackers,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) print(snapshot.error);
      //       return snapshot.hasData
      //           ? TrackerList(
      //               context: context,
      //               projectName: projectDetail.name,
      //               trackers: snapshot.data)
      //           : Center(child: CircularProgressIndicator());
      //     }),
      InkWell(
        // decoration:  BoxDecoration(
        //   color: Colors.white54,
        //   border:  Border.all(
        //     color: Colors.orange,
        //     width: 1.0
        //   )
        // ),
        child: Text(
          '${projectDetail.description}',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Raleway',
            fontSize: 11.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            // TrackerList(context: context, projectName: projectDetail.name, trackers: );
          }));
        },
      ),
      SizedBox(
        height: 10.0,
      )
    ]);
  }
}
