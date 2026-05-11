import 'package:flutter/material.dart';

import '../models/station_model.dart';
import '../services/station_service.dart';

class StationProvider extends ChangeNotifier {

  final StationService _service = StationService();

  List<Station> stations = [];
  bool isLoading = false;

  Future<void> loadStations() async {
    isLoading = true;
    notifyListeners();
    stations =
        await _service.getStations();
    isLoading = false;
    notifyListeners();
  }
}