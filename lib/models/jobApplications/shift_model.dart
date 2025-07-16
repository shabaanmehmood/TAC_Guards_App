class Shift {
  final String id;
  final String date;
  final List<String> days;
  final String startTime;
  final String endTime;
  final String timePeriod;

  Shift({
    required this.id,
    required this.date,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.timePeriod,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    id: json['id'],
    date: json['date'],
    days: List<String>.from(json['days']),
    startTime: json['startTime'],
    endTime: json['endTime'],
    timePeriod: json['timePeriod'],
  );
}
