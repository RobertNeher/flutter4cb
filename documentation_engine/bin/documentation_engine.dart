import 'dart:io';
import '../src/association.dart';
import '../src/fieldDoc.dart';
import '../src/projectDoc.dart';
import '../src/trackerDoc.dart';
import '../../lib/src/field.dart';
import '../../lib/src/project.dart';
import '../../lib/src/tracker.dart';

void main(List<String> args) async {
  if (args.length != 1) {
    print('Usage:\nargs <ID of project to be documented>');
    exit(-1);
  }
  int projectID = int.parse(args[0]);

  /*
   * Get all trackers and post them in tracker "Tracker"
   */
  Project project = await lookupProjectName(projectID);

  if (project.id == 0) {
    project = await documentProject(projectID);
  }

  if (project.id != 0) {
    List<Tracker> trackers = await fetchProjectTrackers(projectID);
    print('$projectID: Tracker: ${trackers.length}');

    if (trackers != null) {
      trackers.forEach((tracker) async {
        Tracker trackerItem = await lookupTrackerName(tracker.name);

        if (trackerItem == null) {
          trackerItem = await documentTracker(project, tracker) as Tracker;
        }

        bool result = await associate(trackerItem.id, project.id);
        // print(result
        //     ? 'Project "${project.name}" is associated with tracker "${tracker.name}"'
        //     : 'Association failed from project ${project.name} to ${tracker.name}');
        print(trackerItem);
        List<Field> fields = await fetchTrackerFields(trackerItem.trackerID);
        if (fields != null) {
          fields.forEach((field) async {
            bool fieldFound = await lookupFieldName(field.name);

            if (!fieldFound) {
              Field fieldItem =
                  await documentField(trackerItem.trackerID, field.id) as Field;
            }

            bool result = await associate(trackerItem.id, field.id);
            print(result
                ? 'Tracker "${tracker.name}" is associated with field "${field.name}"'
                : 'Association failed from tracker ${tracker.name} to ${field.name}');
          });
        }
        print('Tracker ${trackerItem.name} (${trackerItem.id}) processed');
      });
    }
    print('Project ${project.name} (${project.id}) processed');
  }
  // Wartenb bis alle Requests terminiert sind (Wait 20)
}
