// data/dto/lost_and_found_dto.dart
class LostAndFoundDto {
  final String id;
  final String type;
  final String description;
  final String location;
  final String date;
  final String time;
  final String contactInfo;

  LostAndFoundDto({
    required this.id,
    required this.type,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.contactInfo,
  });

  factory LostAndFoundDto.fromJson(Map<String, dynamic> json) {
    return LostAndFoundDto(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      contactInfo: json['contactInfo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'location': location,
      'date': date,
      'time': time,
      'contactInfo': contactInfo,
    };
  }
}
