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
    // Detect system brightness to dynamically adjust shadow colors for better depth.
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        return CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          items: provider.programs.map((program) {
            return GestureDetector(
              onTap: () => _showProgramDetail(
                context, 
                program
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.6)
                          : Colors.grey.withOpacity(0.4),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
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
                          gradient:  LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(
                                0.7,
                              ),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        right: 14,
                        child:
                            Consumer<FavoritesProvider>(
                          builder: (
                            context,
                            favProvider,
                            _,
                          ) {
                            final isFav =
                                favProvider.isFavorite(
                              "program_${program.title}",
                            );
                            return GestureDetector(
                              onTap: () {
                                favProvider.toggleFavorite(
                                  itemId:
                                      "program_${program.title}",
                                  type: "program",
                                  title: program.title,
                                  image: program.imageUrl,
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    Colors.black54,
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 15,
                        right: 15,
                        child: Text(
                          program.title,
                          style: const TextStyle(
                            color:  Colors.white,
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
      },
    );
  }

  /// Displays a stylized bottom sheet containing the full program description.
  void _showProgramDetail(BuildContext context, dynamic program) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
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
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                /// DESCRIPCION
                Text(
                  program.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),

                const SizedBox(height: 10),

                /// HORARIOS (esto lo pide el inge)
                const Text(
                  "Horario: 6:30 AM - 8:30 AM",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 15),

                /// BOTON CERRAR
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}