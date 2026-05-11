import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/event_model.dart';

class EventsService {

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  // CREAR EVENTO
  Future<void> createEvent({
    required String userId,
    required EventModel event,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('events')
        .add(event.toMap());
  }

  // OBTENER EVENTOS
  Stream<List<EventModel>> getEvents(
    String userId,
  ) {

    return _db
        .collection('users')
        .doc(userId)
        .collection('events')
        .orderBy(
          'startDate',
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {

              return EventModel.fromMap(
                doc.id,
                doc.data(),
              );
            },
          ).toList(),
        );
  }

  // ACTUALIZAR EVENTO
  Future<void> updateEvent({
    required String userId,
    required EventModel event,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(event.id)
        .update(
          event.toMap(),
        );
  }

  // ELIMINAR EVENTO
  Future<void> deleteEvent({
    required String userId,
    required String eventId,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .delete();
  }
}