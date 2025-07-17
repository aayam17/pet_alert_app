import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/entity/lost_and_found_entity.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/add_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/delete_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/get_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/update_lost_and_found_use_case.dart';
import 'lost_and_found_state.dart';

class LostAndFoundCubit extends Cubit<LostAndFoundState> {
  final GetLostAndFoundUseCase getUseCase;
  final AddLostAndFoundUseCase addUseCase;
  final UpdateLostAndFoundUseCase updateUseCase;
  final DeleteLostAndFoundUseCase deleteUseCase;

  LostAndFoundCubit({
    required this.getUseCase,
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  }) : super(LostAndFoundInitial());

  void loadEntries() async {
    emit(LostAndFoundLoading());
    try {
      final items = await getUseCase();
      emit(LostAndFoundLoaded(items));
    } catch (_) {
      emit(LostAndFoundError("Failed to load entries"));
    }
  }

  void addEntry(LostAndFoundEntity entry) async {
    try {
      await addUseCase(entry);
      loadEntries();
    } catch (_) {
      emit(LostAndFoundError("Failed to add entry"));
    }
  }

  void updateEntry(String id, LostAndFoundEntity entry) async {
    try {
      await updateUseCase(id, entry);
      loadEntries();
    } catch (_) {
      emit(LostAndFoundError("Failed to update entry"));
    }
  }

  void deleteEntry(String id) async {
    try {
      await deleteUseCase(id);
      loadEntries();
    } catch (_) {
      emit(LostAndFoundError("Failed to delete entry"));
    }
  }
}
