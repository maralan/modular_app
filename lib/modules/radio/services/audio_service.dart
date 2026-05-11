import 'package:just_audio/just_audio.dart';

// Service class responsible for the low-level management of the just_audio player instance.
class AudioService {
  // Private instance of the AudioPlayer to handle the actual media playback logic.
  final AudioPlayer _player = AudioPlayer();

  // Getter to provide external read-only access to the player instance for state monitoring.
  AudioPlayer get player => _player;

  /// Loads a specific audio stream URL and begins playback.
  Future<void> play(String url) async {
    // Sets the audio source before starting playback.
    await _player.setUrl(url);
    _player.play();
  }

  /// Completely stops the audio playback and resets the player's internal buffering.
  Future<void> stop() async {
    await _player.stop();
  }

  /// Suspends playback, allowing it to be resumed from the current position later.
  Future<void> pause() async {
    await _player.pause();
  }

  /// Permanently releases the player resources when the service is no longer needed.
  /// This is crucial to prevent memory leaks and free up hardware audio decoders.
  void dispose() {
    _player.dispose();
  }
}