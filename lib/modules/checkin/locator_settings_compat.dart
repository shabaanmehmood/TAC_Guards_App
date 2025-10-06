// This file provides missing settings classes for background_locator_2 compatibility.

class IOSSettings {
  final dynamic accuracy;
  final int distanceFilter;
  const IOSSettings({required this.accuracy, required this.distanceFilter});
}

class AndroidSettings {
  final dynamic accuracy;
  final int distanceFilter;
  const AndroidSettings({required this.accuracy, required this.distanceFilter});
}
