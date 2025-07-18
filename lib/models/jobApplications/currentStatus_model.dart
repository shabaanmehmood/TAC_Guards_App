import 'package:tac/models/jobApplications/shift_model.dart';

class CurrentStatus {
  final String id;
  final String status;
  final String reason;


  CurrentStatus({
    required this.id,
    required this.status,
    required this.reason,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
    id: json['id'],
    status: json['status'] ?? '',
    reason: json['reason'] ?? '',
  );
}
