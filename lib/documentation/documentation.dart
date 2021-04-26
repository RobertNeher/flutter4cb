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
    await documentProject(project.projectID);
  }

  if (project != null) {
    int result;
    List<Tracker> trackers = await fetchProjectTrackers(project.projectID);

    trackers.forEach((tracker) async {
      // trackerItem = await lookupTrackerName(tracker.name);
      // print('${tracker.id}: ${tracker.name}');
      // if (trackerItem.trackerID > 0) {
      result = await documentTracker(project.projectID, tracker.id);
      print(result);
      // }
    });

    /*
   * Get all fields of a tracker and post them in tracker "Field"
   * Options of a selecion field will be posted in tracker "Option"
   * Status will be posted to tracker "Status"
   */
  }
}
