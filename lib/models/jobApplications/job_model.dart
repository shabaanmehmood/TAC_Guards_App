import 'package:tac/models/jobApplications/preferences_model.dart';
import 'package:tac/models/jobApplications/premisesType_model.dart';
import 'package:tac/models/jobApplications/skill_model.dart';

import '../shift_model.dart';
import 'category_model.dart';
import 'contractor_model.dart';

class Job {
  final String id;
  final String title;
  final String payPerHour;
  final String description;
  final String status;
  final String jobType;
  final String responsibilities;
  final String location;
  final String latitude;
  final String longitude;
  final int noOfGuardsRequired;
  final bool leaderRequired;
  final String jobSOPs;
  final String? reportingManagerNumber;
  final String? reportingManagerName;
  final String? minAge;
  final String? maxAge;
  final String minumumLevel;
  final String maximumLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Contractor contractor;
  final Category category;
  final PremisesType premisesType;
  final List<Shift> shifts;
  final List<Skill> skills;
  final List<Preference> preferences;

  Job({
    required this.id,
    required this.title,
    required this.payPerHour,
    required this.description,
    required this.status,
    required this.jobType,
    required this.responsibilities,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.noOfGuardsRequired,
    required this.leaderRequired,
    required this.jobSOPs,
    this.reportingManagerNumber,
    this.reportingManagerName,
    this.minAge,
    this.maxAge,
    required this.minumumLevel,
    required this.maximumLevel,
    required this.createdAt,
    required this.updatedAt,
    required this.contractor,
    required this.category,
    required this.premisesType,
    required this.shifts,
    required this.skills,
    required this.preferences,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json['id'],
    title: json['title'],
    payPerHour: json['payPerHour'],
    description: json['description'],
    status: json['status'],
    jobType: json['jobType'],
    responsibilities: json['responsibilities'],
    location: json['location'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    noOfGuardsRequired: json['noOfGuardsRequired'],
    leaderRequired: json['leaderRequired'],
    jobSOPs: json['jobSOPs'],
    reportingManagerNumber: json['reportingManagerNumber'] ?? '',
    reportingManagerName: json['reportingManagerName'] ?? '',
    minAge: json['minAge'] ?? '',
    maxAge: json['maxAge'] ?? '',
    minumumLevel: json['minumumLevel'],
    maximumLevel: json['maximumLevel'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    contractor: Contractor.fromJson(json['contractor']),
    category: Category.fromJson(json['category']),
    premisesType: PremisesType.fromJson(json['premisesType']),
    shifts: (json['shifts'] as List<dynamic>).map((e) => Shift.fromJson(e)).toList(),
    skills: (json['skills'] as List<dynamic>).map((e) => Skill.fromJson(e)).toList(),
    preferences: (json['preferences'] as List<dynamic>).map((e) => Preference.fromJson(e)).toList(),
  );
}
