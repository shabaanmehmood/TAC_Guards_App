import 'dart:convert';

// Root model
class ContractorsResponse {
  final String? message;
  final int? status;
  final List<Contractor>? data;

  ContractorsResponse({this.message, this.status, this.data});

  factory ContractorsResponse.fromJson(Map<String, dynamic> json) {
    return ContractorsResponse(
      message: json['message'],
      status: json['status'],
      data: json['data'] != null
          ? List<Contractor>.from(json['data'].map((x) => Contractor.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "status": status,
      "data": data?.map((x) => x.toJson()).toList()
    };
  }
}

class Contractor {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final String? dob;
  final String? token;
  final bool? isVerified;
  final String? phone;
  final String? gender;
  final String? appleId;
  final String? fcmToken;
  final bool? isActive;
  final bool? isDeleted;
  final String? postalAddress;
  final String? postalCode;
  final String? masterSecurityLicense;
  final String? australianBusinessNumber;
  final String? australianCompanyNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? registeringAs;
  final AccountInfo? accountInfo;
  final List<PersonalDetail>? personalDetails;

  Contractor({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.dob,
    this.token,
    this.isVerified,
    this.phone,
    this.gender,
    this.appleId,
    this.fcmToken,
    this.isActive,
    this.isDeleted,
    this.postalAddress,
    this.postalCode,
    this.masterSecurityLicense,
    this.australianBusinessNumber,
    this.australianCompanyNumber,
    this.createdAt,
    this.updatedAt,
    this.registeringAs,
    this.accountInfo,
    this.personalDetails,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      dob: json['dob'],
      token: json['token'],
      isVerified: json['isVerified'],
      phone: json['phone'],
      gender: json['gender'],
      appleId: json['appleId'],
      fcmToken: json['fcmToken'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      postalAddress: json['postalAddress'],
      postalCode: json['postalCode'],
      masterSecurityLicense: json['masterSecurityLicense'],
      australianBusinessNumber: json['australianBusinessNumber'],
      australianCompanyNumber: json['australianCompanyNumber'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      registeringAs: json['registeringAs'],
      accountInfo: json['accountInfo'] != null
          ? AccountInfo.fromJson(json['accountInfo'])
          : null,
      personalDetails: json['personalDetails'] != null
          ? List<PersonalDetail>.from(
          json['personalDetails'].map((x) => PersonalDetail.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "dob": dob,
      "token": token,
      "isVerified": isVerified,
      "phone": phone,
      "gender": gender,
      "appleId": appleId,
      "fcmToken": fcmToken,
      "isActive": isActive,
      "isDeleted": isDeleted,
      "postalAddress": postalAddress,
      "postalCode": postalCode,
      "masterSecurityLicense": masterSecurityLicense,
      "australianBusinessNumber": australianBusinessNumber,
      "australianCompanyNumber": australianCompanyNumber,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "registeringAs": registeringAs,
      "accountInfo": accountInfo?.toJson(),
      "personalDetails": personalDetails?.map((x) => x.toJson()).toList(),
    };
  }
}

class AccountInfo {
  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? designation;
  final String? alternatePhoneNumber;
  final String? workExperience;

  AccountInfo({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.designation,
    this.alternatePhoneNumber,
    this.workExperience,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      designation: json['designation'],
      alternatePhoneNumber: json['alternatePhoneNumber'],
      workExperience: json['workExperience'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "designation": designation,
      "alternatePhoneNumber": alternatePhoneNumber,
      "workExperience": workExperience,
    };
  }
}

class PersonalDetail {
  final int? id;
  final int? yearsOfExperience;
  final String? licenseNumber;
  final String? abn;
  final List<String>? preferredLocationAddresses;
  final String? createdDate;
  final String? updatedDate;

  PersonalDetail({
    this.id,
    this.yearsOfExperience,
    this.licenseNumber,
    this.abn,
    this.preferredLocationAddresses,
    this.createdDate,
    this.updatedDate,
  });

  factory PersonalDetail.fromJson(Map<String, dynamic> json) {
    return PersonalDetail(
      id: json['id'],
      yearsOfExperience: json['yearsOfExperience'],
      licenseNumber: json['licenseNumber'],
      abn: json['abn'],
      preferredLocationAddresses: json['preferredLocationAddresses'] != null
          ? List<String>.from(json['preferredLocationAddresses'])
          : [],
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "yearsOfExperience": yearsOfExperience,
      "licenseNumber": licenseNumber,
      "abn": abn,
      "preferredLocationAddresses": preferredLocationAddresses,
      "createdDate": createdDate,
      "updatedDate": updatedDate,
    };
  }
}
