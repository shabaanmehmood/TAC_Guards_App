import 'package:tac/models/jobApplications/personalDetails_model.dart';

class Contractor {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String dob;
  final bool isVerified;
  final String phone;
  final String gender;
  final bool isActive;
  final bool isDeleted;
  final String postalAddress;
  final String? postalCode;
  final String? masterSecurityLicense;
  final String australianBusinessNumber;
  final String? australianCompanyNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String registeringAs;
  final List<PersonalDetail> personalDetails;

  Contractor({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.dob,
    required this.isVerified,
    required this.phone,
    required this.gender,
    required this.isActive,
    required this.isDeleted,
    required this.postalAddress,
    this.postalCode,
    this.masterSecurityLicense,
    required this.australianBusinessNumber,
    this.australianCompanyNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.registeringAs,
    required this.personalDetails,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) => Contractor(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    password: json['password'],
    role: json['role'],
    dob: json['dob'],
    isVerified: json['isVerified'],
    phone: json['phone'],
    gender: json['gender'],
    isActive: json['isActive'],
    isDeleted: json['isDeleted'],
    postalAddress: json['postalAddress'],
    postalCode: json['postalCode'],
    masterSecurityLicense: json['masterSecurityLicense'],
    australianBusinessNumber: json['australianBusinessNumber'],
    australianCompanyNumber: json['australianCompanyNumber'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    registeringAs: json['registeringAs'],
    personalDetails: (json['personalDetails'] as List<dynamic>?)
        ?.map((e) => PersonalDetail.fromJson(e))
        .toList() ?? [],
  );
}
