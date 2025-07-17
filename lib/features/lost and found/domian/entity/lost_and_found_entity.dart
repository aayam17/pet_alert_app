// domain/entity/lost_and_found_entity.dart
class LostAndFoundEntity {
  final String id;
  final String type;
  final String description;
  final String location;
  final String date;
  final String time;
  final String contactInfo;

  LostAndFoundEntity({
    required this.id,
    required this.type,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.contactInfo,
  });
}
