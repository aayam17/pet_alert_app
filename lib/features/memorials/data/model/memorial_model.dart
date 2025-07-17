// data/model/memorial_model.dart
import 'package:pet_alert_app/features/memorials/data/dto/memorial_dto.dart';
import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';

class MemorialModel {
  final String id;
  final String petName;
  final String message;
  final String dateOfPassing;
  final String imageUrl;

  MemorialModel({
    required this.id,
    required this.petName,
    required this.message,
    required this.dateOfPassing,
    required this.imageUrl,
  });

  factory MemorialModel.fromDto(MemorialDto dto) => MemorialModel(
        id: dto.id,
        petName: dto.petName,
        message: dto.message,
        dateOfPassing: dto.dateOfPassing,
        imageUrl: dto.imageUrl,
      );

  MemorialDto toDto() => MemorialDto(
        id: id,
        petName: petName,
        message: message,
        dateOfPassing: dateOfPassing,
        imageUrl: imageUrl,
      );

  MemorialEntity toEntity() => MemorialEntity(
        id: id,
        petName: petName,
        message: message,
        dateOfPassing: dateOfPassing,
        imageUrl: imageUrl,
      );

  factory MemorialModel.fromEntity(MemorialEntity entity) => MemorialModel(
        id: entity.id,
        petName: entity.petName,
        message: entity.message,
        dateOfPassing: entity.dateOfPassing,
        imageUrl: entity.imageUrl,
      );
}
