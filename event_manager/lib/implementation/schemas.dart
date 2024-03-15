class CalendarEventDataToLocal {
  final DateTime date;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;

  CalendarEventDataToLocal({
    required this.date,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  // Convert CalendarEventData to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  // Create CalendarEventData object from JSON
  factory CalendarEventDataToLocal.fromJson(Map<String, dynamic> json) {
    return CalendarEventDataToLocal(
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}
