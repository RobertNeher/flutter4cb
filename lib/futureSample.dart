import 'package:booking_controller/booking_controller.dart';
import 'package:configuration/configuration.dart';
import 'package:flutter4cb/src/project.dart';

Future<void> main() async {
  List<DateTime> bd = new List<DateTime>();

  await getBlockedDays().then((value) => value.forEach((element) {
        print(element);
        bd.add(element);
      }));

  print('The length is: ${bd}');
}
