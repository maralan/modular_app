import 'package:flutter/material.dart';
import 'package:modular_app/modules/app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  AppUser? user;
  String? errorMessage; 

  bool get isLoggedIn => user != null;

  AuthProvider() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((firebaseUser) {
      if (firebaseUser != null) {
        user = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
        );
      } else {
        user = null;
      }
      notifyListeners();
    });
    checkSession();
  }
  
  Future<void> checkSession() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      user = AppUser(
        uid: firebaseUser.uid, 
        email: firebaseUser.email!,
      );
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    user = await _authService.login(email, password);

    if (user == null) {
      errorMessage = "Credenciales incorrrectas";
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    user = await _authService.register(email, password);

    if (user == null) {
      errorMessage = "No se pudo registrar";
    }
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    await _authService.logout();
    user = null;
    isLoading = false;
    notifyListeners();
  }
}