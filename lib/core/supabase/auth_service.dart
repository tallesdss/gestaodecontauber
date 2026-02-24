import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_app_client.dart';

class AuthService {
  AuthService._();

  static final GoTrueClient _auth = supabaseClient.auth;

  /// Retorna o usuário logado, se houver.
  static User? get currentUser => _auth.currentUser;

  /// Retorna se há uma sessão ativa.
  static bool get isAuthenticated => _auth.currentSession != null;

  /// Stream para monitorar mudanças no estado de autenticação.
  static Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  /// Registro de novos usuários com e-mail e senha.
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await _auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  /// Login com e-mail e senha.
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Logout do usuário.
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Reset de senha.
  static Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(email);
  }

  /// Atualização de senha (para quando o usuário já está logado ou veio do link de recuperação).
  static Future<UserResponse> updatePassword(String newPassword) async {
    return await _auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}
