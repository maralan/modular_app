import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/station_model.dart';
import '../provider/audio_provider.dart';

// A UI component that represents a single radio station with its branding and playback controls.
class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    // Consumer rebuilds this widget whenever the AudioProvider notifies changes.
    return Consumer<AudioProvider>(
      builder: (context, provider, _) {
        // Logic to determine if this specific card is the one currently active in the provider.
        final isCurrent = provider.currentStation == station;
        final isPlaying = isCurrent && provider.isPlaying;

        return Container(
          height: 180,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Stack(
            children: [

              /// Background branding image for the station.
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: station.imageUrl.isNotEmpty
                    ? Image.network(
                      station.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        StackTrace,
                      ) {
                        return Container(
                          color: Theme.of(context).dividerColor,
                          child: const Icon(
                            Icons.radio,
                            size: 40,
                          ),
                        );
                      },
                    )
                    : Container(
                      color: Theme.of(context).dividerColor,
                      child: const Icon(
                        Icons.radio,
                        size: 40,
                      ),
                    ),
              ),
              /// A dark gradient overlay to ensure the white text remains legible against bright images.
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),

              /// Displays the station name and slogan.
              Positioned(
                left: 16,
                bottom: 16,
                right: 80, // Leaves enough space so text doesn't overlap with the Play button.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      station.slogan,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              /// Main playback toggle button for this specific station.
              Positioned(
                right: 16,
                bottom: 16,
                child: GestureDetector(
                  onTap: () {
                    if (isPlaying) {
                      // If this station is already playing, the action is to pause.
                      provider.pause();
                    } else {
                      // If it's not playing (or another station was playing), switch to this one.
                      provider.playStation(station);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.3),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    // Dynamically switches the icon based on the current playback state.
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.onSecondary,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}