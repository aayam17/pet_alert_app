import '../repository/lost_and_found_repository.dart';

class DeleteLostAndFoundUseCase {
  final LostAndFoundRepository repo;
  DeleteLostAndFoundUseCase(this.repo);

  Future<void> call(String id) => repo.deleteEntry(id);
}
