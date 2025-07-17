// data/dto/vaccination_record_dto.dart
class VaccinationRecordDto {
  final String id;
  final String vaccine;
  final String notes;
  final String date;

  VaccinationRecordDto({
    required this.id,
    required this.vaccine,
    required this.notes,
    required this.date,
  });

  factory VaccinationRecordDto.fromJson(Map<String, dynamic> json) {
    return VaccinationRecordDto(
      id: json['_id'] ?? '',
      vaccine: json['vaccine'],
      notes: json['notes'] ?? '',
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vaccine': vaccine,
      'notes': notes,
      'date': date,
    };
  }
}
