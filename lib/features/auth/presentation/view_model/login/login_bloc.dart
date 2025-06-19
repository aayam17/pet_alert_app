import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_event.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await loginUseCase(event.email, event.password);

      if (result) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        emit(state.copyWith(isLoading: false, isSuccess: false, error: 'Invalid credentials'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, isSuccess: false, error: 'Login failed: ${e.toString()}'));
    }
  }
}
