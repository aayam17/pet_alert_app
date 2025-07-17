import '../entity/memorial_entity.dart';
import '../repository/memorial_repository.dart';

class AddMemorialUseCase {
  final MemorialRepository repository;

  AddMemorialUseCase(this.repository);

  Future<void> call(MemorialEntity memorial) {
    return repository.addMemorial(memorial);
  }
}
