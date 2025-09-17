import 'package:tac/models/jobApplications/shift_model.dart';

class CurrentStatus {
  final String id;
  final String status;
  final String? reason;          // ← nullable

  CurrentStatus({
    required this.id,
    required this.status,
    this.reason,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) => CurrentStatus(
    id: json['id'] as String,
    status: json['status'] ?? '',
    reason: json['reason'] as String?,
  );
}
