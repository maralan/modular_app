import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../provider/events_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() =>
      _EventsScreenState();
}

class _EventsScreenState
    extends State<EventsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      Provider.of<EventsProvider>(
        context,
        listen: false,
      ).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
        Provider.of<EventsProvider>(context);

    return Scaffold(

      body: provider.isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : provider.events.isEmpty
              ? const Center(
                  child: Text(
                    "No hay eventos",
                  ),
                )
              : ListView.builder(
                  itemCount:
                      provider.events.length,
                  itemBuilder:
                      (context, index) {

                    final event =
                        provider.events[index];

                    return Card(
                      margin:
                          const EdgeInsets.all(
                        10,
                      ),

                      child: ListTile(

                        title: Text(
                          event.title,
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Text(
                              event.description,
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              "Inicio: ${event.startDate}",
                            ),

                            Text(
                              "Fin: ${event.endDate}",
                            ),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                              ),
                              onPressed: () {

                                showEventDialog(
                                  event: event,
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {

                                await provider
                                    .deleteEvent(
                                  event.id,
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

          showEventDialog();
        },

        child: const Icon(Icons.add),
      ),
    );
  }

  // DIALOGO
  void showEventDialog({
    EventModel? event,
  }) {

    final titleController =
        TextEditingController(
      text: event?.title ?? '',
    );

    final descriptionController =
        TextEditingController(
      text: event?.description ?? '',
    );

    DateTime startDate =
        event?.startDate ??
            DateTime.now();

    DateTime endDate =
        event?.endDate ??
            DateTime.now();

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(

          title: Text(
            event == null
                ? "Nueva Evento"
                : "Editar Evento",
          ),

          content: StatefulBuilder(
            builder:
                (context, setStateDialog) {

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [

                    TextField(
                      controller:
                          titleController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Título",
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    TextField(
                      controller:
                          descriptionController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Descripción",
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ElevatedButton(
                      onPressed: () async {

                        final picked =
                            await showDatePicker(
                          context: context,
                          initialDate:
                              startDate,
                          firstDate:
                              DateTime(2020),
                          lastDate:
                              DateTime(2100),
                        );

                        if (picked != null) {

                          setStateDialog(() {

                            startDate =
                                picked;
                          });
                        }
                      },

                      child: Text(
                        "Inicio: ${startDate.toLocal()}",
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    ElevatedButton(
                      onPressed: () async {

                        final picked =
                            await showDatePicker(
                          context: context,
                          initialDate:
                              endDate,
                          firstDate:
                              DateTime(2020),
                          lastDate:
                              DateTime(2100),
                        );

                        if (picked != null) {

                          setStateDialog(() {

                            endDate =
                                picked;
                          });
                        }
                      },

                      child: Text(
                        "Fin: ${endDate.toLocal()}",
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          actions: [

            TextButton(
              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text(
                "Cancelar",
              ),
            ),

            ElevatedButton(
              onPressed: () async {

                final provider =
                    Provider.of<
                        EventsProvider>(
                  context,
                  listen: false,
                );

                final newEvent =
                    EventModel(
                  id: event?.id ?? '',
                  title:
                      titleController.text,
                  description:
                      descriptionController
                          .text,
                  startDate: startDate,
                  endDate: endDate,
                );

                if (event == null) {

                  await provider
                      .createEvent(
                    newEvent,
                  );
                } else {

                  await provider
                      .updateEvent(
                    newEvent,
                  );
                }

                Navigator.pop(context);
              },

              child: const Text(
                "Guardar",
              ),
            ),
          ],
        );
      },
    );
  }
}