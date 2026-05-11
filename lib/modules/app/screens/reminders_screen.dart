import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reminder_model.dart';
import '../provider/reminders_provider.dart';

import '../services/notifications/notification_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() =>
      _RemindersScreenState();
}

class _RemindersScreenState
    extends State<RemindersScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<RemindersProvider>(
        context,
        listen: false,
      ).loadReminders();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
        Provider.of<RemindersProvider>(context);

    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showReminderDialog(context);
        },
        child: const Icon(Icons.add_alarm),
      ),

      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.reminders.isEmpty
              ? const Center(
                  child: Text(
                    "No hay recordatorios",
                  ),
                )
              : ListView.builder(
                  itemCount:
                      provider.reminders.length,

                  itemBuilder: (context, index) {

                    final reminder =
                        provider.reminders[index];

                    return Card(
                      margin:
                          const EdgeInsets.all(10),

                      child: ListTile(

                        leading: const Icon(
                          Icons.alarm,
                          color: Colors.deepPurple,
                        ),

                        title: Text(
                          "${reminder.scheduledAt.day}/"
                          "${reminder.scheduledAt.month}/"
                          "${reminder.scheduledAt.year}",
                        ),

                        subtitle: Text(
                          "${reminder.scheduledAt.hour}:"
                          "${reminder.scheduledAt.minute}",
                        ),

                        onTap: () {
                          _showReminderDialog(
                            context,
                            reminder: reminder,
                          );
                        },

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),

                          onPressed: () async {

                            await provider
                                .deleteReminder(
                              reminder.id,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // DIALOG
  Future<void> _showReminderDialog(
    BuildContext context, {
    ReminderModel? reminder,
  }) async {

    final provider =
        Provider.of<RemindersProvider>(
      context,
      listen: false,
    );

    bool isEditing =
        reminder != null;

    DateTime selectedDate =
        reminder?.scheduledAt ??
            DateTime.now();

    TimeOfDay selectedTime =
        TimeOfDay.fromDateTime(
      reminder?.scheduledAt ??
          DateTime.now(),
    );

    await showDialog(
      context: context,

      builder: (context) {

        return StatefulBuilder(
          builder: (context, setState) {

            return AlertDialog(

              title: Text(
                isEditing
                    ? "Editar Recordatorio"
                    : "Nuevo Recordatorio",
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  ElevatedButton(

                    onPressed: () async {

                      final pickedDate =
                          await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate:
                            DateTime.now(),
                        lastDate:
                            DateTime(2100),
                      );

                      if (pickedDate != null) {

                        setState(() {
                          selectedDate =
                              pickedDate;
                        });
                      }
                    },

                    child: Text(
                      "Fecha: "
                      "${selectedDate.day}/"
                      "${selectedDate.month}/"
                      "${selectedDate.year}",
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(

                    onPressed: () async {

                      final pickedTime =
                          await showTimePicker(
                        context: context,
                        initialTime:
                            selectedTime,
                      );

                      if (pickedTime != null) {

                        setState(() {
                          selectedTime =
                              pickedTime;
                        });
                      }
                    },

                    child: Text(
                      "Hora: "
                      "${selectedTime.hour}:"
                      "${selectedTime.minute}",
                    ),
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

                    final fullDate =
                        DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    final newReminder =
                        ReminderModel(
                      id: reminder?.id ?? '',
                      scheduledAt: fullDate,
                    );

                    if (isEditing) {

                      await provider
                          .updateReminder(
                        newReminder,
                      );

                    } else {

                      await provider
                          .createReminder(
                        newReminder,
                      );

                      await NotificationService.scheduleNotification(
                        id: DateTime.now().millisecondsSinceEpoch ~/ 1000, 
                        title: "Recordatorio", 
                        body: "Tienes una alerta pendiente",
                        scheduledDate: fullDate, 
                      );
                    }

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(

                      SnackBar(
                        content: Text(
                          isEditing
                              ? "Recordatorio actualizado"
                              : "Recordatorio creado",
                        ),
                      ),
                    );
                  },

                  child: Text(
                    isEditing
                        ? "Actualizar"
                        : "Guardar",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}