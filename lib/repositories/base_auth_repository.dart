import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthRepository {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
}
