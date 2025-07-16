import 'assignedShift_model.dart';
import 'currentStatus_model.dart';
import 'job_model.dart';

class JobApplication {
  final String id;
  final DateTime appliedAt;
  final DateTime updatedAt;
  final Job job;
  final CurrentStatus currentStatus;
  final AssignedShift assignedShift;

  JobApplication({
    required this.id,
    required this.appliedAt,
    required this.updatedAt,
    required this.job,
    required this.currentStatus,
    required this.assignedShift,
  });

  factory JobApplication.fromJson(Map json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);
    return JobApplication(
      id: data['id'],
      appliedAt: DateTime.parse(data['appliedAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      job: Job.fromJson(Map<String, dynamic>.from(data['job'])),
      currentStatus: CurrentStatus.fromJson(Map<String, dynamic>.from(data['currentStatus'])),
      assignedShift: AssignedShift.fromJson(Map<String, dynamic>.from(data['assignedShift'])),
    );
  }
}
