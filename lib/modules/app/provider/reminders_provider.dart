import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/reminder_model.dart';
import '../services/firebase/reminders_service.dart';

class RemindersProvider extends ChangeNotifier {

  final RemindersService _service =
      RemindersService();

  List<ReminderModel> reminders = [];

  bool isLoading = false;

  // CARGAR
  void loadReminders() {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    isLoading = true;

    notifyListeners();

    _service.getReminders(user.uid)
        .listen((data) {

      reminders = data;

      isLoading = false;

      notifyListeners();
    });
  }

  // CREAR
  Future<void> createReminder(
    ReminderModel reminder,
  ) async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.createReminder(
      userId: user.uid,
      reminder: reminder,
    );
  }

  // ACTUALIZAR
  Future<void> updateReminder(
    ReminderModel reminder,
  ) async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.updateReminder(
      userId: user.uid,
      reminder: reminder,
    );
  }

  // ELIMINAR
  Future<void> deleteReminder(
    String reminderId,
  ) async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.deleteReminder(
      userId: user.uid,
      reminderId: reminderId,
    );
  }
}