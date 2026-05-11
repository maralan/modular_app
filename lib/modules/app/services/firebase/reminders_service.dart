import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/reminder_model.dart';

class RemindersService {

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  // CREAR
  Future<void> createReminder({
    required String userId,
    required ReminderModel reminder,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .add(reminder.toMap());
  }

  // OBTENER
  Stream<List<ReminderModel>> getReminders(
    String userId,
  ) {

    return _db
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .orderBy('scheduledAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {

              return ReminderModel.fromMap(
                doc.id,
                doc.data(),
              );
            },
          ).toList(),
        );
  }

  // ACTUALIZAR
  Future<void> updateReminder({
    required String userId,
    required ReminderModel reminder,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .doc(reminder.id)
        .update(reminder.toMap());
  }

  // ELIMINAR
  Future<void> deleteReminder({
    required String userId,
    required String reminderId,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .doc(reminderId)
        .delete();
  }
}