// data/model/lost_and_found_model.dart
import 'package:pet_alert_app/features/lost%20and%20found/data/dto/lost_and_found_dto.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/entity/lost_and_found_entity.dart';

class LostAndFoundModel {
  final String id;
  final String type;
  final String description;
  final String location;
  final String date;
  final String time;
  final String contactInfo;

  LostAndFoundModel({
    required this.id,
    required this.type,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.contactInfo,
  });

  /// ✅ Convert from DTO
  factory LostAndFoundModel.fromDto(LostAndFoundDto dto) => LostAndFoundModel(
        id: dto.id,
        type: dto.type,
        description: dto.description,
        location: dto.location,
        date: dto.date,
        time: dto.time,
        contactInfo: dto.contactInfo,
      );

  /// ✅ Convert from Entity
  factory LostAndFoundModel.fromEntity(LostAndFoundEntity entity) =>
      LostAndFoundModel(
        id: entity.id,
        type: entity.type,
        description: entity.description,
        location: entity.location,
        date: entity.date,
        time: entity.time,
        contactInfo: entity.contactInfo,
      );

  /// ✅ Convert to DTO for API
  LostAndFoundDto toDto() => LostAndFoundDto(
        id: id,
        type: type,
        description: description,
        location: location,
        date: date,
        time: time,
        contactInfo: contactInfo,
      );

  /// ✅ Convert to Entity
  LostAndFoundEntity toEntity() => LostAndFoundEntity(
        id: id,
        type: type,
        description: description,
        location: location,
        date: date,
        time: time,
        contactInfo: contactInfo,
      );
}
