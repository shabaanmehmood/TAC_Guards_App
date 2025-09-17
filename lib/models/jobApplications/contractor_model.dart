import 'package:tac/models/jobApplications/personalDetails_model.dart';

class Contractor {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String dob;
  final bool isVerified;
  final String? phone;                       // ← nullable
  final String gender;
  final bool isActive;
  final bool isDeleted;
  final String? postalAddress;               // ← nullable
  final String? postalCode;                  // ← nullable
  final String? masterSecurityLicense;       // ← nullable
  final String? australianBusinessNumber;    // ← nullable
  final String? australianCompanyNumber;     // ← nullable
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? registeringAs;               // ← nullable
  final List<PersonalDetail> personalDetails;

  Contractor({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.dob,
    required this.isVerified,
    this.phone,
    required this.gender,
    required this.isActive,
    required this.isDeleted,
    this.postalAddress,
    this.postalCode,
    this.masterSecurityLicense,
    this.australianBusinessNumber,
    this.australianCompanyNumber,
    required this.createdAt,
    required this.updatedAt,
    this.registeringAs,
    required this.personalDetails,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) => Contractor(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    role: json['role'] as String,
    dob: json['dob'] as String,
    isVerified: json['isVerified'] as bool,
    phone: json['phone'] as String?,
    gender: json['gender'] as String,
    isActive: json['isActive'] as bool,
    isDeleted: json['isDeleted'] as bool,
    postalAddress: json['postalAddress'] as String?,
    postalCode: json['postalCode'] as String?,
    masterSecurityLicense: json['masterSecurityLicense'] as String?,
    australianBusinessNumber: json['australianBusinessNumber'] as String?,
    australianCompanyNumber: json['australianCompanyNumber'] as String?,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    registeringAs: json['registeringAs'] as String?,
    personalDetails: (json['personalDetails'] as List<dynamic>?)
        ?.map((e) => PersonalDetail.fromJson(e))
        .toList() ??
        [],
  );
}