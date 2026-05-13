class Program {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String day;
  final String startTime;
  final String endTime;

  Program({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory Program.fromJson(
    Map<String, dynamic> json,
  ) {

    return Program(
      id: json['id'] ?? 0,
      title: json['program_name'] ?? '',
      description: json['program_description'] ?? '',
      imageUrl: json['program_cover'] ?? '',
      day: '',
      startTime: '',
      endTime: '',
    );
  }
}