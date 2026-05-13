import 'package:flutter/material.dart';
import '../models/program_model.dart';

class ProgramCard  extends StatelessWidget {
  final Program program;

  const ProgramCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
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
                        color: theme.dividerColor,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: theme.iconTheme.color,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: theme.dividerColor,
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 40,
                        color: theme.iconTheme.color,
                      ),
                    ),
                  ),

            Container(
              color: theme.shadowColor.withOpacity(0.4),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                program.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: theme.shadowColor,
                      blurRadius: 6
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}