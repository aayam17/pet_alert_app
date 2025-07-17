import '../repository/memorial_repository.dart';

class DeleteMemorialUseCase {
  final MemorialRepository repository;

  DeleteMemorialUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteMemorial(id);
  }
}
