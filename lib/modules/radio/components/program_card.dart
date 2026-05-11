import 'package:flutter/material.dart';
import '../models/program_model.dart';

class ProgramCard  extends StatelessWidget {
  final Program program;

  const ProgramCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Provides horizontal spacing between adjacent cards in a scrollable view.
      margin: const EdgeInsets.symmetric(horizontal: 8),
      
      // Ensures the children (images and overlays) respect the rounded corner boundary.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            /// Background image representing the specific radio program.
            program.imageUrl.isNotEmpty
                ? Image.network(
                    program.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,

                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 40,
                      ),
                    ),
                  ),

            /// Semi-transparent dark overlay to improve text readability against varying image backgrounds.
            Container(
              color: Colors.black.withOpacity(0.4),
            ),

            /// Anchored text label displaying the program title at the bottom of the card.
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                program.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}