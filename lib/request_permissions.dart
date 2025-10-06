import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  if (await Permission.locationWhenInUse.request().isGranted) {
    await Permission.locationAlways.request();
  }
}
