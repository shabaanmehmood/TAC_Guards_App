class Preference {
  final String id;
  final String? requiredSkills;   // ← nullable
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
    id: json['id'] as String,
    requiredSkills: json['requiredSkills'] as String?,
    minYearsExperience: json['minYearsExperience'] as int,
    maxYearsExperience: json['maxYearsExperience'] as int,
    appearanceRequirements: json['appearanceRequirements'] as String,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}