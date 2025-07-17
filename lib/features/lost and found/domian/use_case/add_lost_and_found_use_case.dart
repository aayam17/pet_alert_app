import '../entity/lost_and_found_entity.dart';
import '../repository/lost_and_found_repository.dart';

class AddLostAndFoundUseCase {
  final LostAndFoundRepository repo;
  AddLostAndFoundUseCase(this.repo);

  Future<void> call(LostAndFoundEntity entry) => repo.addEntry(entry);
}
