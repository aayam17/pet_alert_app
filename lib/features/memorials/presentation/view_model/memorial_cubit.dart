import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/app/service_locator/service_locator.dart';
import 'package:pet_alert_app/features/memorials/data/repository/remote_repository/memorial_repository_impl.dart';
import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/add_memorial_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/delete_memorial_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/get_memorials_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/update_memorial_use_case.dart';
import 'memorial_state.dart';

class MemorialCubit extends Cubit<MemorialState> {
  final GetMemorialsUseCase getUseCase;
  final AddMemorialUseCase addUseCase;
  final UpdateMemorialUseCase updateUseCase;
  final DeleteMemorialUseCase deleteUseCase;

  MemorialCubit({
    required this.getUseCase,
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  }) : super(MemorialInitial());

  void loadMemorials() async {
    emit(MemorialLoading());
    try {
      final data = await getUseCase();
      emit(MemorialLoaded(data));
    } catch (e) {
      emit(MemorialError("Failed to load memorials"));
    }
  }

  void addMemorial(MemorialEntity entity) async {
    try {
      await addUseCase(entity);
      loadMemorials();
    } catch (_) {
      emit(MemorialError("Failed to add memorial"));
    }
  }

  void updateMemorial(String id, MemorialEntity entity) async {
    try {
      await updateUseCase(id, entity);
      loadMemorials();
    } catch (_) {
      emit(MemorialError("Failed to update memorial"));
    }
  }

  void deleteMemorial(String id) async {
    try {
      await deleteUseCase(id);
      loadMemorials();
    } catch (_) {
      emit(MemorialError("Failed to delete memorial"));
    }
  }

  /// ✅ Upload Image via Remote DataSource
  Future<String> uploadImage(String filePath) async {
    try {
      final remote = getIt.get<MemorialRepositoryImpl>().remote;
      return await remote.uploadImage(filePath);
    } catch (e) {
      throw Exception("Image upload failed");
    }
  }
}
