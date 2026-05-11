import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/note_model.dart';

class NotesService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CREAR NOTA
  Future<void> createNote({
    required String userId,
    required NoteModel note,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(note.toMap());
  }

  // OBTENER NOTAS
  Stream<List<NoteModel>> getNotes(String userId) {

    return _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('pinned', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              return NoteModel.fromMap(
                doc.id,
                doc.data(),
              );
            },
          ).toList(),
        );
  }

  // ACTUALIZAR NOTA
  Future<void> updateNote({
    required String userId,
    required NoteModel note,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  // ELIMINAR NOTA
  Future<void> deleteNote({
    required String userId,
    required String noteId,
  }) async {

    await _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}