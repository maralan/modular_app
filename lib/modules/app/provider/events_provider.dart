import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event_model.dart';
import '../services/firebase/events_service.dart';

class EventsProvider extends ChangeNotifier {

  final EventsService _service =
      EventsService();

  List<EventModel> events = [];

  bool isLoading = false;

  // CARGAR EVENTOS
  void loadEvents() {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    isLoading = true;
    notifyListeners();

    _service.getEvents(user.uid).listen(
      (data) {

        events = data;

        isLoading = false;

        notifyListeners();
      },
    );
  }

  // CREAR EVENTO
  Future<void> createEvent(
    EventModel event,
  ) async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.createEvent(
      userId: user.uid,
      event: event,
    );
  }

  // ACTUALIZAR EVENTO
  Future<void> updateEvent(
    EventModel event,
  ) async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.updateEvent(
      userId: user.uid,
      event: event,
    );
  }

  // ELIMINAR EVENTO
  Future<void> deleteEvent(
    String eventId,
  ) async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.deleteEvent(
      userId: user.uid,
      eventId: eventId,
    );
  }
}