import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<AppUser?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

        if (doc.exists && doc.data() != null) {
          return AppUser.fromMap(doc.data()!);
        } else {
          return AppUser(
            uid: user.uid, 
            email: user.email ?? email,
          );
        }
      }
      return null;
    } catch (e) {
      print("Error login: $e");
      return null;
    }
  }

  Future<AppUser?> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        final appUser = AppUser(
          uid: user.uid, 
          email: user.email!,
          name: '',
          birthDate: '',
          gender: '',
          civilStatus: '',
          provider: 'email',
          photoUrl: '',
          createdAt:
              DateTime.now()
                  .toIso8601String(),
        );

        await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(appUser.toMap());

        return appUser;
      }

      return null;
    } catch (e) {
      print("Error register: $e");
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error reset password: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}