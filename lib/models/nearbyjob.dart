class NearbyJobsResponses {
  final List<JobNearby> data;

  NearbyJobsResponses({required this.data});

  factory NearbyJobsResponses.fromJson(Map<String, dynamic> json) {
    return NearbyJobsResponses(
      data: (json['data'] as List).map((i) => JobNearby.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class JobNearby {
  final String jobId;
  final String jobTitle;
  final String jobDescription;
  final String jobResponsibilities;
  final String jobLocation;
  final String jobLatitude;
  final String jobLongitude;
  final int noOfGuardsRequired;
  final int leaderRequired;
  final String jobStatus;
  final String payPerHour;
  final String jobSOPs;
  final String jobCreatedAt;
  final String jobUpdatedAt;
  final String contractorId;
  final String contractorName;
  final String categoryId;
  final String categoryName;
  final String premisesTypeId;
  final String premisesTypeName;
  final String licenseId;
  final String licenseName;
  final String licenseBasicPic;
  final String? requiredSkills;
  final int minYearsExperience;
  final int maxYearsExperience;
  final String appearanceRequirements;
  final String profileImageId;
  final String profileImageUrl;
  final int profileImageIsMain;
  final double distance;
  final List<ContractorProfileImage> contractorProfileImages;
  final List<dynamic> skills;
  final List<Shift> shifts;

  JobNearby({
    required this.jobId,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobResponsibilities,
    required this.jobLocation,
    required this.jobLatitude,
    required this.jobLongitude,
    required this.noOfGuardsRequired,
    required this.leaderRequired,
    required this.jobStatus,
    required this.payPerHour,
    required this.jobSOPs,
    required this.jobCreatedAt,
    required this.jobUpdatedAt,
    required this.contractorId,
    required this.contractorName,
    required this.categoryId,
    required this.categoryName,
    required this.premisesTypeId,
    required this.premisesTypeName,
    required this.licenseId,
    required this.licenseName,
    required this.licenseBasicPic,
    this.requiredSkills,
    required this.minYearsExperience,
    required this.maxYearsExperience,
    required this.appearanceRequirements,
    required this.profileImageId,
    required this.profileImageUrl,
    required this.profileImageIsMain,
    required this.distance,
    required this.contractorProfileImages,
    required this.skills,
    required this.shifts,
  });

  factory JobNearby.fromJson(Map<String, dynamic> json) {
    return JobNearby(
      jobId: json['jobId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      jobDescription: json['jobDescription'] ?? '',
      jobResponsibilities: json['jobResponsibilities'] ?? '',
      jobLocation: json['jobLocation'] ?? '',
      jobLatitude: json['jobLatitude'] ?? '',
      jobLongitude: json['jobLongitude'] ?? '',
      noOfGuardsRequired: json['noOfGuardsRequired'] ?? 0,
      leaderRequired: json['leaderRequired'] ?? 0,
      jobStatus: json['jobStatus'] ?? '',
      payPerHour: json['payPerHour'] ?? '',
      jobSOPs: json['jobSOPs'] ?? '',
      jobCreatedAt: json['jobCreatedAt'] ?? '',
      jobUpdatedAt: json['jobUpdatedAt'] ?? '',
      contractorId: json['contractorId'] ?? '',
      contractorName: json['contractorName'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      premisesTypeId: json['premisesTypeId'] ?? '',
      premisesTypeName: json['premisesTypeName'] ?? '',
      licenseId: json['licenseId'] ?? '',
      licenseName: json['licenseName'] ?? '',
      licenseBasicPic: json['licenseBasicPic'] ?? '',
      requiredSkills: json['requiredSkills'],
      minYearsExperience: json['minYearsExperience'] ?? 0,
      maxYearsExperience: json['maxYearsExperience'] ?? 0,
      appearanceRequirements: json['appearanceRequirements'] ?? '',
      profileImageId: json['profileImageId'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      profileImageIsMain: json['profileImageIsMain'] ?? 0,
      distance: (json['distance'] ?? 0.0).toDouble(),
      contractorProfileImages: (json['contractorProfileImages'] as List?)
              ?.map((i) => ContractorProfileImage.fromJson(i))
              .toList() ??
          [],
      skills: json['skills'] ?? [],
      shifts: (json['shifts'] as List?)
              ?.map((i) => Shift.fromJson(i))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'jobResponsibilities': jobResponsibilities,
      'jobLocation': jobLocation,
      'jobLatitude': jobLatitude,
      'jobLongitude': jobLongitude,
      'noOfGuardsRequired': noOfGuardsRequired,
      'leaderRequired': leaderRequired,
      'jobStatus': jobStatus,
      'payPerHour': payPerHour,
      'jobSOPs': jobSOPs,
      'jobCreatedAt': jobCreatedAt,
      'jobUpdatedAt': jobUpdatedAt,
      'contractorId': contractorId,
      'contractorName': contractorName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'premisesTypeId': premisesTypeId,
      'premisesTypeName': premisesTypeName,
      'licenseId': licenseId,
      'licenseName': licenseName,
      'licenseBasicPic': licenseBasicPic,
      'requiredSkills': requiredSkills,
      'minYearsExperience': minYearsExperience,
      'maxYearsExperience': maxYearsExperience,
      'appearanceRequirements': appearanceRequirements,
      'profileImageId': profileImageId,
      'profileImageUrl': profileImageUrl,
      'profileImageIsMain': profileImageIsMain,
      'distance': distance,
      'contractorProfileImages': contractorProfileImages.map((e) => e.toJson()).toList(),
      'skills': skills,
      'shifts': shifts.map((e) => e.toJson()).toList(),
    };
  }
}

class ContractorProfileImage {
  final String id;
  final String url;
  final int isMain;

  ContractorProfileImage({
    required this.id,
    required this.url,
    required this.isMain,
  });

  factory ContractorProfileImage.fromJson(Map<String, dynamic> json) {
    return ContractorProfileImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      isMain: json['isMain'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'isMain': isMain,
    };
  }
}

class Shift {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final List<String> days;
  final String timePeriod;

  Shift({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.days,
    required this.timePeriod,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      days: List<String>.from(json['days'] ?? []),
      timePeriod: json['timePeriod'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'days': days,
      'timePeriod': timePeriod,
    };
  }
}