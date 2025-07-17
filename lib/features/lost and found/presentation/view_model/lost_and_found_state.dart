import 'package:pet_alert_app/features/lost%20and%20found/domian/entity/lost_and_found_entity.dart';

abstract class LostAndFoundState {}

class LostAndFoundInitial extends LostAndFoundState {}

class LostAndFoundLoading extends LostAndFoundState {}

class LostAndFoundLoaded extends LostAndFoundState {
  final List<LostAndFoundEntity> entries;
  LostAndFoundLoaded(this.entries);
}

class LostAndFoundError extends LostAndFoundState {
  final String message;
  LostAndFoundError(this.message);
}
