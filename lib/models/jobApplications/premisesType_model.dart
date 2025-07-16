class PremisesType {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  PremisesType({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PremisesType.fromJson(Map<String, dynamic> json) => PremisesType(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
