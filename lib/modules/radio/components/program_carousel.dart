import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../provider/program_provider.dart';

import '../../app/provider/favorites_provider.dart';

// An interactive carousel widget that showcases featured radio programs.
class ProgramCarousel extends StatelessWidget {
  const ProgramCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ProgramProvider>(
      builder: (context, provider, _){
        if (provider.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (provider.programs.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                "No hay programas disponibles",
              ),
            ),
          );
        }
        return Consumer<FavoritesProvider>(
          builder: (content, favProvider, _) {
            return CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: provider.programs.map((program) {
                final isFav =
                    favProvider.isFavorite(
                  "program_${program.id}",
                );

                return GestureDetector(
                  onTap: () => _showProgramDetail(
                    context,
                    program,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.25),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [

                          Positioned.fill(
                            child: Image.network(
                              program.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  theme.shadowColor.withOpacity(0.7),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 14,
                            right: 14,
                            child: GestureDetector(
                              onTap: () {
                                favProvider.toggleFavorite(
                                  itemId:
                                      "program_${program.id}",
                                  type: "program",
                                  title: program.title,
                                  image: program.imageUrl,
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    theme.shadowColor.withOpacity(0.45),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 15,
                            left: 15,
                            right: 15,
                            child: Text(
                              program.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        );
      },
    );
  }

  /// Displays a stylized bottom sheet containing the full program description.
  void _showProgramDetail(BuildContext context, dynamic program) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// IMAGEN
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(program.imageUrl),
                ),

                const SizedBox(height: 15),

                /// TITULO
                Text(
                  program.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 10),

                /// DESCRIPCION
                Text(
                  program.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                ),

                const SizedBox(height: 10),

                /// HORARIOS
                Text(
                  "Horario: 6:30 AM - 8:30 AM",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),

                const SizedBox(height: 15),

                /// BOTON CERRAR
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cerrar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}