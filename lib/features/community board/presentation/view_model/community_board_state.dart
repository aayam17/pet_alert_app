import 'package:pet_alert_app/features/lost and found/domian/entity/lost_and_found_entity.dart';
import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';

abstract class CommunityBoardState {}

class CommunityBoardInitial extends CommunityBoardState {}

class CommunityBoardLoading extends CommunityBoardState {}

class CommunityBoardLoaded extends CommunityBoardState {
  final List<LostAndFoundEntity> lostFound;
  final List<MemorialEntity> memorials;

  CommunityBoardLoaded({
    required this.lostFound,
    required this.memorials,
  });
}

class CommunityBoardError extends CommunityBoardState {
  final String message;
  CommunityBoardError(this.message);
}
