import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter4cb/src/configuration.dart';
import 'package:flutter4cb/src/tableView.dart';
import 'src/project.dart';

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
    final Configuration config = Configuration();
    List<List<String>> data = [];
    Future<List<Project>> projects = fetchProjectsExtended();
    final List<String> headers = ['ID', 'Name', 'Description'];
    final Map<int, double> colWidths = {0: 50, 1: 150, 2: 300};

    return Scaffold(
        appBar: AppBar(
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'images/BHC.png',
            fit: BoxFit.contain,
            height: 50.0,
            alignment: Alignment.center,
          ),
          Container(
              padding: EdgeInsets.all(4.0),
              child: Text(title,
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ))),
        ])),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          SizedBox(
            height: 5.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                color: Colors.grey[400],
                padding: EdgeInsets.all(4.0),
                child: Text(
                    'Projects on codebeamer server at http://${config.baseURLs['homeServer']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ))),
          ]),
          SizedBox(
            height: 5.0,
          ),
          Expanded(
              flex: 20,
              child: FutureBuilder<List<Project>>(
                  future: projects,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        snapshot.data.forEach((project) {
                          data.add([
                            project.id.toString(),
                            project.name,
                            project.description
                          ]);
                        });
                        return tableView(
                            context, data, headers, colWidths, 'Project');
                      } else
                        return Center(child: Text('no data?'));
                    }
                  })),
        ]));
  }
}
