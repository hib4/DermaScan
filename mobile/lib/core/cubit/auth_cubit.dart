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
    print('[AuthCubit] Checking auth status...');
    emit(AuthLoading());
    try {
      final ok = await _authService.isAuthenticated();
      print('[AuthCubit] Authenticated: $ok');
      emit(ok ? AuthAuthenticated() : AuthUnauthenticated());
    } catch (e) {
      print('[AuthCubit] Auth check failed: $e');
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    print('[AuthCubit] Login attempt: $email');
    emit(AuthLoading());
    try {
      await _authService.login(email: email, password: password);
      print('[AuthCubit] Login successful');
      emit(AuthAuthenticated());
    } on AuthException catch (e) {
      print('[AuthCubit] Login failed: ${e.message}');
      emit(AuthError(e.message));
    } catch (e) {
      print('[AuthCubit] Login error: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({required String email, required String password}) async {
    print('[AuthCubit] Register attempt: $email');
    emit(AuthLoading());
    try {
      await _authService.register(email: email, password: password);
      print('[AuthCubit] Register successful');
      emit(AuthUnauthenticated());
    } on ConflictException catch (e) {
      print('[AuthCubit] Register failed: ${e.message}');
      emit(AuthError(e.message));
    } catch (e) {
      print('[AuthCubit] Register error: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    print('[AuthCubit] Logout');
    await _authService.logout();
    emit(AuthUnauthenticated());
  }
}
