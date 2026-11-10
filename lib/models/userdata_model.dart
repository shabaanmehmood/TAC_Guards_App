import 'package:tac/models/personaldetails_model.dart';
import 'package:tac/models/profileImages_model.dart';
import 'package:tac/models/userLicenses_model.dart';

import 'bankDetails_model.dart';
import 'documents_model.dart';

class UserDataModel {
  String? message;
  Data? data;
  int? status;

  UserDataModel({this.message, this.data, this.status});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  String? id;
  String? fullName;
  String? email;
  String? phone;
  String? postalAddress;
  String? postalCode;
  String? level;
  String? professionalBadge;
  String? masterSecurityLicense;
  String? password;
  String? role;
  String? dob;
  String? token;
  String? accessToken;
  bool? isVerified;
  String? fcmToken;
  String? gender;
  bool? isActive;
  bool? isDeleted;
  String? createdDate;
  String? updatedDate;
  String? appleId;
  List<ProfileImages>? profileImages;
  PersonalDetails? personalDetails;
  List<Documents>? documents;
  List<BankDetails>? bankDetails;
  List<UserLicenses>? userLicenses;

  Data({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.postalAddress,
    this.postalCode,
    this.level,
    this.professionalBadge,
    this.masterSecurityLicense,
    this.password,
    this.role,
    this.dob,
    this.token,
    this.accessToken,
    this.isVerified,
    this.fcmToken,
    this.gender,
    this.isActive,
    this.isDeleted,
    this.createdDate,
    this.updatedDate,
    this.appleId,
    this.profileImages,
    this.personalDetails,
    this.documents,
    this.bankDetails,
    this.userLicenses,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    postalAddress = json['postalAddress'];
    postalCode = json['postalCode'];
    level = json['level'];
    professionalBadge = json['professionalBadge'];
    masterSecurityLicense = json['masterSecurityLicense'];
    password = json['password'];
    role = json['role'];
    dob = json['dob'];
    token = json['token'];
    accessToken = json['accessToken'];
    isVerified = json['isVerified'];
    fcmToken = json['fcmToken'];
    gender = json['gender'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    appleId = json['appleId'];

    if (json['profileImages'] != null) {
      profileImages = <ProfileImages>[];
      json['profileImages'].forEach((v) {
        profileImages!.add(ProfileImages.fromJson(v));
      });
    }

    personalDetails = json['personalDetails'] != null
        ? PersonalDetails.fromJson(json['personalDetails'])
        : null;

    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    if (json['bankDetails'] != null) {
      bankDetails = <BankDetails>[];
      json['bankDetails'].forEach((v) {
        bankDetails!.add(BankDetails.fromJson(v));
      });
    }
    if (json['userLicenses'] != null) {
      userLicenses = <UserLicenses>[];
      json['userLicenses'].forEach((v) {
        userLicenses!.add(UserLicenses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['postalAddress'] = postalAddress;
    data['postalCode'] = postalCode;
    data['level'] = level;
    data['professionalBadge'] = professionalBadge;
    data['masterSecurityLicense'] = masterSecurityLicense;
    data['password'] = password;
    data['role'] = role;
    data['dob'] = dob;
    data['token'] = token;
    data['accessToken'] = accessToken;
    data['isVerified'] = isVerified;
    data['fcmToken'] = fcmToken;
    data['gender'] = gender;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    data['appleId'] = appleId;

    if (profileImages != null) {
      data['profileImages'] = profileImages!.map((v) => v.toJson()).toList();
    }

    if (personalDetails != null) {
      data['personalDetails'] = personalDetails!.toJson();
    }

    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }

    if (bankDetails != null) {
      data['bankDetails'] = bankDetails!.map((v) => v.toJson()).toList();
    }

    if (userLicenses != null) {
      data['userLicenses'] = userLicenses!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
