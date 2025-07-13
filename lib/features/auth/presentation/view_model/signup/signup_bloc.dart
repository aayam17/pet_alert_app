import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../domain/use_case/signup_usecase.dart';
import '../../../data/model/user_model.dart';
import '../../../domain/entity/auth_entity.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  SignupBloc({required this.signupUseCase}) : super(SignupState.initial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
  SignupSubmitted event,
  Emitter<SignupState> emit,
) async {
  emit(state.copyWith(isLoading: true));

  try {
    final user = await signupUseCase(AuthEntity(
      name: event.name,
      email: event.email,
      password: event.password,
    ));

    // Save token to Hive
    final box = await Hive.openBox('authBox');
    await box.put('token', user.token);

    emit(state.copyWith(
      isLoading: false,
      isSuccess: true,
      user: user,
    ));
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      isSuccess: false,
      error: 'Signup failed: ${e.toString()}',
    ));
  }
}

}
