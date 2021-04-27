import 'dart:io';
import 'package:flutter4cb/documentation/projectDoc.dart';
import 'package:flutter4cb/documentation/trackerDoc.dart';
// import '../src/configuration.dart';
import '../src/project.dart';
import '../src/tracker.dart';

void main(List<String> args) async {
  // Configuration config = Configuration();

  if (args.length != 1) {
    print('Usage:\nargs <Name of project to be documented>');
    exit(-1);
  }

  /*
   * Get all trackers and post them in tracker "Tracker"
   */
  Project project = await lookupProjectName(args[0]);

  if (project == null) {
    project = await documentProject(project.projectID);
  }

  if (project != null) {
    Tracker result;
    List<Tracker> trackers = await fetchProjectTrackers(project.projectID);

    if (trackers != null) {
      trackers.forEach((tracker) async {
        Tracker item = await lookupTrackerName(tracker.name);

        if (item == null) {
          result = await documentTracker(project, tracker);
        }
      }
    );
  }
  /*
   * Get all fields of a tracker and post them in tracker "Field"
   * Options of a selecion field will be posted in tracker "Option"
   * Status will be posted to tracker "Status"
   */
  }
}
