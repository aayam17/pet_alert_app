import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../data/model/user_model.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final box = Hive.box<AuthApiModel>('users');
    final user = box.values.firstWhere(
      (u) => u.email == event.email && u.password == event.password,
      orElse: () => AuthApiModel(email: '', password: ''),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (user.email.isEmpty) {
      emit(state.copyWith(isLoading: false, isSuccess: false, error: 'Invalid credentials'));
    } else {
      emit(state.copyWith(isLoading: false, isSuccess: true));
    }
  }

}

