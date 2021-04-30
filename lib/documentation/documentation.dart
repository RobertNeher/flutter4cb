import 'dart:io';
import 'package:flutter4cb/documentation/projectDoc.dart';
import 'package:flutter4cb/documentation/trackerDoc.dart';
// import '../src/configuration.dart';
import '../src/project.dart';
import '../src/tracker.dart';
import 'association.dart';

void main(List<String> args) async {
  // Configuration config = Configuration();

  if (args.length != 1) {
    print('Usage:\nargs <ID of project to be documented>');
    exit(-1);
  }
  int projectID = int.parse(args[0]);

  /*
   * Get all trackers and post them in tracker "Tracker"
   */
  Project project = await lookupProjectName(projectID);

  if (project == null) {
    project = await documentProject(projectID);
  }

  if (project != null) {
    print('Project ${project.name} (${project.id}) processed');

    List<Tracker> trackers = await fetchProjectTrackers(projectID);

    if (trackers != null) {
      trackers.forEach((tracker) async {
        Tracker trackerItem = await lookupTrackerName(tracker.name);

        if (trackerItem == null) {
          trackerItem = await documentTracker(project, tracker);
        }
        print('Tracker ${trackerItem.name} (${trackerItem.id}) processed');

        bool result = await associate(trackerItem, project);
        print(result
            ? 'Project ${project.name} is associated with ${tracker.name}'
            : 'Association failed from project ${project.name} to ${tracker.name}');
      });
    }
    /*
   * Get all fields of a tracker and post them in tracker "Field"
   * Options of a selecion field will be posted in tracker "Option"
   * Status will be posted to tracker "Status"
   */
  }
}
