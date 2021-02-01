import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter4cb/src/tracker.dart';
// import 'package:flutter4cb/codebeamer.dart';
import 'package:http/http.dart' as http;
import 'src/project.dart';

void main() => runApp(Flutter4cB());

class Flutter4cB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Flutter - Intland codeBeamer Custom Dialogs';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: StartingPage(title: appTitle),
    );
  }
}

class StartingPage extends StatelessWidget {
  Future<List<Project>> projectsList = fetchProjects();
  final String title;

  StartingPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset(
            'images/BHCLogo.png')),
          title: Text(title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            )
          ),
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder<List<Project>>(
            future: projectsList,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? ProjectList(projects: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
      )
    );
  }
}

class ProjectList extends StatelessWidget {
  final List<Project> projects;

  ProjectList({Key key, this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: projectList(key, projects),
    ));
  }
}

List<Widget> projectList(Key key, List<Project> projects) {
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
          print('Clicked on ${project.id}');
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
  return Column(children: <Widget>[
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
          trackerList(context, projectDetail.id);
        }));
      },
    ),
    SizedBox(
      height: 10.0,
    )
  ]);
}

Widget trackerList(BuildContext context, int projectID) {
  Future<List<Tracker>> trackerList = fetchProjectTrackers(projectID);

  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
    SizedBox(
      height: 10.0,
    ),
    FutureBuilder<List<Tracker>>(
        future: trackerList,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? listTrackers(context, snapshot.data)
              : Center(child: CircularProgressIndicator());
        }),
  ]);
}

Widget listTrackers(BuildContext context, List<Tracker> trackers) {
  List<Widget> list = <Widget>[];

  trackers.forEach((tracker) {
    print(tracker.name);
    list.add(Column(
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
    children: list,
  );
}
