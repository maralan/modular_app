import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/audio_provider.dart';
import '../models/program_model.dart';
import '../provider/program_provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _rotationController;

  // 🔥 Día actual automático
  int selectedDayIndex = DateTime.now().weekday - 1;

  final List<String> days = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo",
  ];

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  // 🔥 MODAL DE PROGRAMA
  void _showProgramModal(Program program) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              program.imageUrl.isNotEmpty
                  ? Image.network(
                      program.imageUrl,
                    )
                  : const Icon(
                      Icons.image,
                      size: 60,
                    ),
              const SizedBox(height: 10),

              Text(
                program.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(program.description),

              const SizedBox(height: 10),

              Text(
                "${program.startTime} - ${program.endTime}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioProvider>();
    if (provider.stations.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final station =
        provider.currentStation ??
        provider.stations.first;
    final color = station.color ?? Colors.blue;

    provider.isPlaying
        ? _rotationController.repeat()
        : _rotationController.stop();

    // por ahora usamos tu lista actual
    final today = days[selectedDayIndex];

    final programProvider =
    context.watch<ProgramProvider>();

    final List<Program> dayPrograms =
        programProvider.programs
            .where(
              (p) =>
                  p.day == today,
            )
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.8,
      maxChildSize: 1,
      builder: (_, controller) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.8),
                Colors.black,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [

                /// CONTENIDO
                SafeArea(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [

                      const SizedBox(height: 70),

                      /// IMAGEN GIRANDO
                      Center(
                        child: RotationTransition(
                          turns: _rotationController,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                NetworkImage(station.imageUrl),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// STATUS
                      Center(
                        child: Text(
                          provider.isPlaying ? "● EN VIVO" : "● OFFLINE",
                          style: TextStyle(
                            color: provider.isPlaying
                                ? Colors.red
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// NOMBRE (aquí luego irá metadata)
                      Center(
                        child: Text(
                          provider.currentTitle.isNotEmpty
                            ? provider.currentTitle
                            : station.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: Text(
                          station.slogan,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// CONTROLES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          IconButton(
                            icon: Icon(Icons.skip_previous,
                                color: color, size: 40),
                            onPressed: provider.previousStation,
                          ),

                          const SizedBox(width: 20),

                          GestureDetector(
                            onTap: () {
                              provider.isPlaying
                                  ? provider.pause()
                                  : provider.resume();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:  color.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: provider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.black)
                                  : Icon(
                                      provider.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          IconButton(
                            icon: Icon(Icons.skip_next,
                                color: color, size: 40),
                            onPressed: provider.nextStation,
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// AHORA EN VIVO
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Text(
                          provider.currentTitle.isNotEmpty
                            ? provider.currentTitle
                            : "Transmitiendo en vivo",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔥 SELECTOR DE DÍAS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () {
                              setState(() {
                                selectedDayIndex =
                                    (selectedDayIndex - 1) < 0
                                        ? 6
                                        : selectedDayIndex - 1;
                              });
                            },
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              days[selectedDayIndex],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                            onPressed: () {
                              setState(() {
                                selectedDayIndex =
                                    (selectedDayIndex + 1) > 6
                                        ? 0
                                        : selectedDayIndex + 1;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔥 PROGRAMAS
                      if (dayPrograms.isEmpty)
                        const Text(
                          "No se encontraron programas",
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        )
                      else
                        Column(
                          children: dayPrograms.map((program) {
                            return GestureDetector(
                              onTap: () => _showProgramModal(program),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    program.imageUrl.isNotEmpty
                                        ? Image.network(
                                            program.imageUrl,
                                            width: 80,
                                          )
                                        : const Icon(
                                            Icons.image,
                                            size: 60,
                                          ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            program.title,
                                            style: const TextStyle(fontWeight:FontWeight.bold),
                                          ),

                                          Text(
                                            "${program.startTime}- ${program.endTime}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),

                                          Text(
                                            program.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),

                /// CERRAR
                Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white, size: 35),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}