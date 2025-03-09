import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signUp(
      password: password,
      email: email,
    );
  }

  // Sign out
  Future<void> signOut() async {
    return await _supabaseClient.auth.signOut();
  }

  // Get user email
  String? getCurrentUserId() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }

  // Get current user session
  Stream<User?> getCurrentUser() => _supabaseClient.auth.onAuthStateChange
      .map((event) => event.session?.user);

  // Get current user authenticated
  User? getSignedInUser() {
    return _supabaseClient.auth.currentUser;
  }
}
