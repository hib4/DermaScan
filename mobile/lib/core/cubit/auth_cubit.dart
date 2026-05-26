import 'package:bloc/bloc.dart';
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/auth_service.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  AuthCubit({required AuthService authService})
      : _authService = authService,
        super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final ok = await _authService.isAuthenticated();
      emit(ok ? AuthAuthenticated() : AuthUnauthenticated());
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _authService.login(email: email, password: password);
      emit(AuthAuthenticated());
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _authService.register(email: email, password: password);
      emit(AuthUnauthenticated());
    } on ConflictException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }
}
