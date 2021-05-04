import 'dart:io';
import '../lib/documentation/fieldDoc.dart';
import '../lib/documentation/projectDoc.dart';
import '../lib/documentation/trackerDoc.dart';
import '../lib/src/configuration.dart';
import '../lib/src/field.dart';
import '../lib/src/project.dart';
import '../lib/src/tracker.dart';
import '../lib/documentation/association.dart';

void main(List<String> args) async {
  Configuration config = Configuration();

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

        bool result = await associate(trackerItem.id, project.id);
        print(result
            ? 'Project "${project.name}" is associated with tracker "${tracker.name}"'
            : 'Association failed from project ${project.name} to ${tracker.name}');

        List<Field> fields = await fetchTrackerFields(trackerItem.trackerID);

        if (fields != null) {
          fields.forEach((field) async {
            print('${tracker.name}: ${field.id} ${field.name}');

            Field fieldItem =
                await lookupFieldName(config.docTrackers['Field'], field.name);

            if (fieldItem == null) {
              Field fieldItem =
                  await documentField(trackerItem.trackerID, field.id);
            }
            print(
                'Field ${fieldItem.name} (${fieldItem.type}) of tracker ${trackerItem.trackerID} is processed');

            bool result = await associate(trackerItem.id, field.id);
            print(result
                ? 'Traacker "${tracker.name}" is associated with field "${field.name}"'
                : 'Association failed from tracker ${tracker.name} to ${field.name}');

          });
        }
      });
    }
  }
}
