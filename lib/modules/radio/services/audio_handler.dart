import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// This class bridges the gap between the audio player logic and the system's background audio service.
class MyAudioHandler extends BaseAudioHandler {
  // Instance of the internal player used for actual audio streaming.
  final AudioPlayer _player = AudioPlayer();

  // Local list to hold station metadata and the index of the current active stream.
  List<Map<String, String>> stations = [];
  int currentIndex = 0;

  MyAudioHandler() {
    /// Listens to the player's internal state and synchronizes it with the system notification.
    _player.playerStateStream.listen((state) {
      final playing = state.playing;

      // Adds the updated state to the audio_service stream so the OS can update the lock screen and notification.
      playbackState.add(
        playbackState.value.copyWith(
          playing: playing,
          // Maps internal processing states (loading, ready, etc.) to the service's expectations.
          processingState: _transformState(state.processingState),
          // Dynamically updates which control buttons are visible in the background notification.
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
            MediaControl.stop,
          ],
        ),
      );
    });
  }

  /// Converts 'just_audio' processing states into 'audio_service' states for consistent system reporting.
  AudioProcessingState _transformState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  /// Updates the internal list of stations available for playback.
  void setStations(List<Map<String, String>> list) {
    stations = list;
  }

  /// Configures and starts playback for a specific station from the list.
  Future<void> playStation(int index) async {
    if (stations.isEmpty) return;

    currentIndex = index;
    final station = stations[index];

    // Updates the current media metadata (Title, Artist, Image) for the OS notification.
    mediaItem.add(
      MediaItem(
        id: station['url'] ?? '',
        title: station['name'] ?? '',
        artist: station['slogan'] ?? '',
        artUri: 
            station['image'] != null &&
                    station['image']!
                        .startsWith('http')
                ? Uri.parse(
                    station['image']! //<--aqui error
                  )
                : null,
      ),
    );

    // Stops any current stream and loads the new URL.
    await _player.stop();

    final streamUrl = station['url'] ?? '';

    if (
        streamUrl.isEmpty ||
        !streamUrl.startsWith('http')
    ) {

      print(
        "URL INVALIDA: $streamUrl",
      );

      return;
    }

    try{
      await _player.setUrl(streamUrl);
      await _player.play();
    } catch (e) {
      print(
        "ERROR STREAM: $e",
      );
    }
  }

  /// Resumes playback of the current stream.
  @override
  Future<void> play() async {
    await _player.play();
  }

  /// Suspends playback of the current stream.
  @override
  Future<void> pause() async {
    await _player.pause();
  }

  /// Terminates the player and shuts down the background service notification.
  @override
  Future<void> stop() async {
    await _player.stop();

    /// Notifies the system that the audio service should be closed completely.
    await super.stop();
  }

  /// Logic to jump to the next station in the circular list.
  @override
  Future<void> skipToNext() async {
    if (stations.isEmpty) return;
    currentIndex = (currentIndex + 1) % stations.length;
    await playStation(currentIndex);
  }

  /// Logic to jump to the previous station in the circular list.
  @override
  Future<void> skipToPrevious() async {
    if (stations.isEmpty) return;
    currentIndex = (currentIndex - 1 + stations.length) % stations.length;
    await playStation(currentIndex);
  }
}