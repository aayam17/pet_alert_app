import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';

abstract class MemorialState {}

class MemorialInitial extends MemorialState {}

class MemorialLoading extends MemorialState {}

class MemorialLoaded extends MemorialState {
  final List<MemorialEntity> memorials;

  MemorialLoaded(this.memorials);

  get entries => null;
}

class MemorialError extends MemorialState {
  final String message;

  MemorialError(this.message);
}
