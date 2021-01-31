import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter4cb/codebeamer.dart';
import 'package:http/http.dart' as http;
import 'src/project.dart';

void main() => runApp(Flutter4cB());

class Flutter4cB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'BHC Offerings for Intland codeBeamer';

    return MaterialApp(
      title: appTitle,
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
          title: Text(title),
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
        ));
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
  // ProjectDetail pd = ProjectDetail();
  List<Widget> list = <Widget>[];

  projects.forEach((project) {
    Future<ProjectDetail> projectDetail = fetchProjectDetail(project.id);

    list.add(Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: 10.0,
      ),
      Container(
          color: Colors.white54,
          child: Text('${project.id}: ${project.name}',
              style: TextStyle(
                color: Colors.orange,
                fontFamily: 'Raleway',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      FutureBuilder<ProjectDetail>(
          future: projectDetail,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ProjectInfo(key, snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    ]));
  });
  return list;
}

Widget ProjectInfo(Key key, ProjectDetail projectDetail) {
  return Column(
    children: <Widget>[
      Container(
        // decoration:  BoxDecoration(
        //   color: Colors.white54,
        //   border:  Border.all(
        //     color: Colors.orange,
        //     width: 1.0
        //   )
        // ),
        child: Text('${projectDetail.description}',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Raleway',
            fontSize: 11.0,
            fontWeight: FontWeight.normal,
          )
        ),
      ),
      SizedBox(
        height: 10.0,
      )
    ]
  );
}
