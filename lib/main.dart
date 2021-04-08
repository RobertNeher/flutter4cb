import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/project.dart';
import 'src/project_list.dart';

void main() => runApp(Flutter4cB());

class Flutter4cB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'codeBeamer Custom Dialogs - Powered by Flutter';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.blue,
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
              child: Image.asset('images/VW.png')),
          title: Text(title,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              )),
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
        ));
  }
}
