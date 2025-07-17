import '../entity/memorial_entity.dart';
import '../repository/memorial_repository.dart';

class GetMemorialsUseCase {
  final MemorialRepository repository;

  GetMemorialsUseCase(this.repository);

  Future<List<MemorialEntity>> call() {
    return repository.getMemorials();
  }
}
