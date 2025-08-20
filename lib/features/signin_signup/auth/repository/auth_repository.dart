import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signUp(String name, String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firebaseAuth.currentUser?.updateDisplayName(name);
    
    // Reload to get updated user data
    await _firebaseAuth.currentUser?.reload();
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
       
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}