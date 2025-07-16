import '../shift_model.dart';

class AssignedShift {
  final String id;
  final String status;
  final bool isLeader;
  final DateTime assignedAt;
  final DateTime updatedAt;
  final Shift shift;

  AssignedShift({
    required this.id,
    required this.status,
    required this.isLeader,
    required this.assignedAt,
    required this.updatedAt,
    required this.shift,
  });

  factory AssignedShift.fromJson(Map<String, dynamic> json) => AssignedShift(
    id: json['id'],
    status: json['status'],
    isLeader: json['isLeader'],
    assignedAt: DateTime.parse(json['assignedAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    shift: Shift.fromJson(json['shift']),
  );
}
