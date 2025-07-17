import 'package:pet_alert_app/features/vaccination%20records/data/dto/vaccination_record_dto.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/entity/vaccination_record_entity.dart';


class VaccinationModel {
  final String id;
  final String vaccine;
  final String notes;
  final String date;

  VaccinationModel({
    required this.id,
    required this.vaccine,
    required this.notes,
    required this.date,
  });

  /// From DTO → Model
  factory VaccinationModel.fromDto(VaccinationRecordDto dto) {
    return VaccinationModel(
      id: dto.id,
      vaccine: dto.vaccine,
      notes: dto.notes,
      date: dto.date,
    );
  }

  /// To DTO → for API
  VaccinationRecordDto toDto() {
    return VaccinationRecordDto(
      id: id,
      vaccine: vaccine,
      notes: notes,
      date: date,
    );
  }

  /// To Entity → used in domain layer
  VaccinationRecordEntity toEntity() {
    return VaccinationRecordEntity(
      id: id,
      vaccine: vaccine,
      notes: notes,
      date: date,
    );
  }

  /// From JSON (if needed for manual parsing)
  factory VaccinationModel.fromJson(Map<String, dynamic> json) {
    return VaccinationModel(
      id: json['_id'] ?? '',
      vaccine: json['vaccine'] ?? '',
      notes: json['notes'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vaccine': vaccine,
      'notes': notes,
      'date': date,
    };
  }
}
