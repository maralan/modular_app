import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/audio_provider.dart';
import '../screens/player_screen.dart';

// A persistent floating player widget that provides quick access to playback controls.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  // Displays the full-screen player using a modal bottom sheet.
  void _openPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // Enables full-screen height and custom gesture handling within the sheet.
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PlayerScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, provider, _) {
        final station = provider.currentStation;

        // Do not render the widget if no station has been selected yet.
        if (station == null) return const SizedBox();

        return GestureDetector(
          onTap: () => _openPlayer(context),

          /// Gesture detection to support swiping up to expand the player.
          onVerticalDragUpdate: (details) {
            // Detects upward motion based on negative delta values.
            if (details.primaryDelta! < -8) {
              _openPlayer(context);
            }
          },

          child: Container(
            height: 80,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.95), // overlay real
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.25),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                /// Station thumbnail image with rounded corners.
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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

                const SizedBox(width: 10),

                /// Display section for station name and current playback status.
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.currentTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        provider.currentArtist.isNotEmpty
                            ? provider.currentArtist
                            : "En vivo",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 12
                        ),
                      ),
                    ],
                  ),
                ),

                /// Interactive control button for toggling play/pause or showing a loading state.
                IconButton(
                  iconSize: 32,
                  icon: provider.isLoading
                      ? SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          provider.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  onPressed: () {
                    if (provider.isPlaying) {
                      provider.pause();
                    } else {
                      provider.resume();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}