// domain/entity/memorial_entity.dart
class MemorialEntity {
  final String id;
  final String petName;
  final String message;
  final String dateOfPassing;
  final String imageUrl;

  MemorialEntity({
    required this.id,
    required this.petName,
    required this.message,
    required this.dateOfPassing,
    required this.imageUrl,
  });
}
