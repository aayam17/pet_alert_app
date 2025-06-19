import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../data/model/user_model.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState.initial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final box = Hive.box<AuthApiModel>('users');
    final exists = box.values.any((u) => u.email == event.email);

    await Future.delayed(const Duration(seconds: 1));

    if (exists) {
      emit(state.copyWith(isLoading: false, isSuccess: false, error: 'Email already registered'));
    } else {
      await box.add(AuthApiModel(email: event.email, password: event.password));
      emit(state.copyWith(isLoading: false, isSuccess: true));
    }
  }
}
