import '../entity/lost_and_found_entity.dart';
import '../repository/lost_and_found_repository.dart';

class GetLostAndFoundUseCase {
  final LostAndFoundRepository repo;
  GetLostAndFoundUseCase(this.repo);

  Future<List<LostAndFoundEntity>> call() => repo.getEntries();
}
