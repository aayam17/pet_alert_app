import '../entity/memorial_entity.dart';
import '../repository/memorial_repository.dart';

class UpdateMemorialUseCase {
  final MemorialRepository repository;

  UpdateMemorialUseCase(this.repository);

  Future<void> call(String id, MemorialEntity memorial) {
    return repository.updateMemorial(id, memorial);
  }
}
