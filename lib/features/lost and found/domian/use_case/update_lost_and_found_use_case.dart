import '../entity/lost_and_found_entity.dart';
import '../repository/lost_and_found_repository.dart';

class UpdateLostAndFoundUseCase {
  final LostAndFoundRepository repo;
  UpdateLostAndFoundUseCase(this.repo);

  Future<void> call(String id, LostAndFoundEntity entry) => repo.updateEntry(id, entry);
}
