// data/dto/memorial_dto.dart
class MemorialDto {
  final String id;
  final String petName;
  final String message;
  final String dateOfPassing;
  final String imageUrl;

  MemorialDto({
    required this.id,
    required this.petName,
    required this.message,
    required this.dateOfPassing,
    required this.imageUrl,
  });

  factory MemorialDto.fromJson(Map<String, dynamic> json) {
    return MemorialDto(
      id: json['_id'] ?? '',
      petName: json['petName'] ?? '',
      message: json['message'] ?? '',
      dateOfPassing: json['dateOfPassing'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petName': petName,
      'message': message,
      'dateOfPassing': dateOfPassing,
      'imageUrl': imageUrl,
    };
  }
}
