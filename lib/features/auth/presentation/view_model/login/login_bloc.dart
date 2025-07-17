import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_case/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

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
      final user = await loginUseCase(event.email, event.password);

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: 'Login failed: ${e.toString()}',
      ));
    }
  }
}
