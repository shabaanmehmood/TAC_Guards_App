class JobModel {
  final String title;
  final String guardName;
  final String rating;
  final String location;
  final String distance;
  final String time;
  final String status; // e.g., "Pending", "In Progress", "Awaiting"
  final String statusLabel; // e.g., "Check In", "Check Out", or custom tag
  final String price; // used for Completed
  final String? remainingTime; // e.g., "2h 30m left" for Awaiting/In Progress
  final List<String>? nestedCards; // only for Pending
  final bool showButton;
  final String? buttonText;
  String? id;
  JobModel({
    required this.title,
    required this.guardName,
    required this.rating,
    required this.location,
    required this.distance,
    required this.time,
    required this.status,
    required this.statusLabel,
    required this.price,
    this.remainingTime,
    this.nestedCards,
    required this.showButton,
    this.buttonText,
    this.id,
  });
}
