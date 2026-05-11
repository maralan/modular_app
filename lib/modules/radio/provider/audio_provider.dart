import 'dart:async';
import 'package:flutter/material.dart';
import '../models/station_model.dart';

import 'package:audio_service/audio_service.dart';
import 'package:modular_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProvider extends ChangeNotifier {
  Station? currentStation;

  bool isPlaying = false;
  bool isLoading = false;

  List<Station> stations = [];

  StreamSubscription? _playbackSub;
  StreamSubscription? _mediaSub;

  String currentTitle = "En vivo";
  String currentArtist = "";

  AudioProvider() {
    _playbackSub = audioHandler.playbackState.listen((state) {
      final newPlaying = state.playing;
      
      // The app is considered loading if it is either fetching the stream or buffering.
      final newLoading =
          state.processingState == AudioProcessingState.loading ||
          state.processingState == AudioProcessingState.buffering;

      // Only trigger a UI update if there is an actual change in state.
      if (isPlaying != newPlaying || isLoading != newLoading) {
        isPlaying = newPlaying;
        isLoading = newLoading;
        notifyListeners();
      }
    });

    /// Listen for changes in the current media item (song or station info).
  _mediaSub = audioHandler.mediaItem.listen((media) {
    if (media == null) return;

    //METADATA REAL
    String title = media.title;
    String artist = media.artist ?? "";

    //FALLBACK INTELIGENTE
    if (title.isEmpty) {
      title = currentStation?.name ?? "En vivo";
    }

    currentTitle = title;
    currentArtist = artist;

    // LÓGICA ORIGINAL (NO SE TOCA)
    if (stations.isEmpty) return;
    final station = stations.firstWhere(
      (s) =>
          s.streamUrl == media.id,
      orElse: () => stations.first,
    );

    if (currentStation?.streamUrl != station.streamUrl) {
      currentStation = station;
    }

    notifyListeners();
  });
  }

  void setStations(List<Station> newStation) {
    stations = newStation;
  }

  Future<void>
      saveLastStation(
    Station station,
  ) async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      'last_station_name',
      station.name,
    );

    await prefs.setString(
      'last_station_image',
      station.imageUrl,
    );

    await prefs.setString(
      'last_station_slogan',
      station.slogan,
    );
  }

  /// Starts playback for a specific radio station.
  Future<void> playStation(Station station) async {
    try {
      final index = stations.indexOf(station);

      audioHandler.setStations(
        stations.map((s) => {
          "url": s.streamUrl,
          "name": s.name,
          "slogan": s.slogan,
          "image": s.imageUrl,
        }).toList(),
      );

      audioHandler.playStation(index);
      await saveLastStation(station);

    } catch (e) {
      debugPrint("AUDIO ERROR: $e");
    }
  }

  /// Suspends the current audio playback.
  Future<void> pause() async {
    await audioHandler.pause();
  }

  /// Resumes playback from a paused state.
  Future<void> resume() async {
    await audioHandler.play();
  }

  /// Switches to the next available station in the list.
  void nextStation() {
    audioHandler.skipToNext();
  }

  /// Switches to the previous station in the list.
  void previousStation() {
    audioHandler.skipToPrevious();
  }

  @override
  void dispose() {
    // Clean up stream subscriptions to prevent memory leaks.
    _playbackSub?.cancel();
    _mediaSub?.cancel();
    super.dispose();
  }
}