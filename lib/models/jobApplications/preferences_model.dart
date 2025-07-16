class Preference {
  final String id;
  final String? requiredSkills;
  final int minYearsExperience;
  final int maxYearsExperience;
  final String appearanceRequirements;
  final DateTime createdAt;
  final DateTime updatedAt;

  Preference({
    required this.id,
    this.requiredSkills,
    required this.minYearsExperience,
    required this.maxYearsExperience,
    required this.appearanceRequirements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Preference.fromJson(Map<String, dynamic> json) => Preference(
    id: json['id'],
    requiredSkills: json['requiredSkills'],
    minYearsExperience: json['minYearsExperience'],
    maxYearsExperience: json['maxYearsExperience'],
    appearanceRequirements: json['appearanceRequirements'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
