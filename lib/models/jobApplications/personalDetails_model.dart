class PersonalDetail {
  final int id;
  final int yearsOfExperience;
  final String licenseNumber;
  final String abn;
  final List<dynamic> preferredLocationAddresses;
  final DateTime createdDate;
  final DateTime updatedDate;

  PersonalDetail({
    required this.id,
    required this.yearsOfExperience,
    required this.licenseNumber,
    required this.abn,
    required this.preferredLocationAddresses,
    required this.createdDate,
    required this.updatedDate,
  });

  factory PersonalDetail.fromJson(Map<String, dynamic> json) => PersonalDetail(
    id: json['id'],
    yearsOfExperience: json['yearsOfExperience'],
    licenseNumber: json['licenseNumber'],
    abn: json['abn'],
    preferredLocationAddresses: json['preferredLocationAddresses'] ?? [],
    createdDate: DateTime.parse(json['createdDate']),
    updatedDate: DateTime.parse(json['updatedDate']),
  );
}
