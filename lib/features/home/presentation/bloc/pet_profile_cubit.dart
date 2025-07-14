import 'package:flutter_bloc/flutter_bloc.dart';
import 'pet_profile_state.dart';

class PetProfileCubit extends Cubit<PetProfileState> {
  PetProfileCubit() : super(const PetProfileState());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateSpecies(String? species) {
    emit(state.copyWith(species: species));
  }

  void updateSex(String? sex) {
    emit(state.copyWith(sex: sex));
  }

  void updateBirthday(DateTime birthday) {
    emit(state.copyWith(birthday: birthday));
  }

  void updateWeight(String? weight) {
    emit(state.copyWith(weight: weight));
  }
}
