class Skill {
  final String id;
  final String name;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Skill({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    id: json['id'],
    name: json['name'],
    isDeleted: json['is_deleted'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
