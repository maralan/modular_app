import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../provider/notes_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
  with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<NotesProvider>(
        context,
        listen: false,
      ).loadNotes();
    });
  }

  @override
  bool get wantKeepAlive => true;

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void showNoteDialog({
    NoteModel? note,
  }) {

    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
    } else {
      titleController.clear();
      contentController.clear();
    }

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(
          title: Text(
            note == null
                ? "Nueva Nota"
                : "Editar Nota",
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Título",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: "Contenido",
                ),
                maxLines: 3,
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: () async {

                final provider =
                    Provider.of<NotesProvider>(
                  context,
                  listen: false,
                );

                final newNote = NoteModel(
                  id: note?.id ?? '',
                  title: titleController.text,
                  content: contentController.text,
                  pinned: false,
                  createdAt: DateTime.now(),
                );

                if (note == null) {
                  await provider.createNote(newNote);
                } else {
                  await provider.updateNote(newNote);
                }

                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    final provider =
        Provider.of<NotesProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Notas"),
      ),

      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.notes.isEmpty
              ? const Center(
                  child: Text("No hay notas"),
                )
              : ListView.builder(
                  itemCount: provider.notes.length,
                  itemBuilder: (context, index) {

                    final note =
                        provider.notes[index];

                    return Card(
                      margin: const EdgeInsets.all(10),

                      child: ListTile(

                        title: Text(note.title),

                        subtitle: Text(note.content),

                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: Icon(
                                note.pinned
                                  ? Icons.push_pin
                                  :Icons.push_pin_outlined,
                                color: note.pinned
                                  ? Colors.orange
                                  : Colors.grey,
                              ),
                              onPressed: () async {
                                final updateNote = NoteModel(
                                  id: note.id, 
                                  title: note.title, 
                                  content: note.content, 
                                  pinned: !note.pinned,
                                  createdAt: note.createdAt,
                                );

                                await provider.updateNote(updateNote);
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                              ),
                              onPressed: () {
                                showNoteDialog(
                                  note: note,
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {

                                await provider.deleteNote(
                                  note.id,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}