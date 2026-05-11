import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note_model.dart';
import '../services/firebase/notes_service.dart';

class NotesProvider extends ChangeNotifier {

  final NotesService _service = NotesService();

  List<NoteModel> notes = [];

  bool isLoading = false;

  // CARGAR NOTAS
  void loadNotes() {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    isLoading = true;
    notifyListeners();

    _service.getNotes(user.uid).listen((data) {

      notes = data;

      isLoading = false;

      notifyListeners();
    });
  }

  // CREAR NOTA
  Future<void> createNote(NoteModel note) async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.createNote(
      userId: user.uid,
      note: note,
    );
  }

  // ACTUALIZAR NOTA
  Future<void> updateNote(NoteModel note) async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.updateNote(
      userId: user.uid,
      note: note,
    );
  }

  // ELIMINAR NOTA
  Future<void> deleteNote(String noteId) async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _service.deleteNote(
      userId: user.uid,
      noteId: noteId,
    );
  }
}