class Program {
  final String title;
  final String description;
  final String imageUrl;
  final String day;
  final String startTime;
  final String endTime;

  Program({
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
      title: json['program_name'] ?? '',
      description: json['program_description'] ?? '',
      imageUrl: json['program_cover'] ?? '',
      day: '',
      startTime: '',
      endTime: '',
    );
  }
}