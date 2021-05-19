import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/project.dart';
import 'src/project_list.dart';

void main() => runApp(Flutter4cB());

class Flutter4cB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'codebeamer Custom Dialogs - Powered by Flutter';

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
  final String title;

  StartingPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<Project>> projectsList = fetchProjects();

    return Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.asset(
                'images/BHC.png',
              )),
          title: Text(title,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Project>>(
            future: projectsList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ProjectList(projects: snapshot.data);
                }
                ;
              }
            }));
  }
}
