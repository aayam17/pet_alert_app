import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/community board/presentation/view_model/community_board_state.dart';
import 'package:pet_alert_app/features/lost and found/domian/use_case/get_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/get_memorials_use_case.dart';

class CommunityBoardCubit extends Cubit<CommunityBoardState> {
  final GetLostAndFoundUseCase getLostUseCase;
  final GetMemorialsUseCase getMemorialsUseCase;

  CommunityBoardCubit({
    required this.getLostUseCase,
    required this.getMemorialsUseCase,
  }) : super(CommunityBoardInitial());

  void loadData() async {
    emit(CommunityBoardLoading());
    try {
      final lostFound = await getLostUseCase();
      final memorials = await getMemorialsUseCase();
      emit(CommunityBoardLoaded(
        lostFound: lostFound,
        memorials: memorials,
      ));
    } catch (_) {
      emit(CommunityBoardError("Failed to load community data"));
    }
  }

  void loadBoard() {
    loadData(); 
  }
}
