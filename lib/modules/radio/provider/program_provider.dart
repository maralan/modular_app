import 'package:flutter/material.dart';
import '../models/program_model.dart';
import '../services/program_service.dart';

class ProgramProvider extends ChangeNotifier {

  final ProgramService _service = ProgramService();

  List<Program> programs = [];
  bool isLoading = false;

  Future<void> loadPrograms() async {
    isLoading = true;
    notifyListeners();
    programs = await _service.getPrograms();
    isLoading = false;
    notifyListeners();
  }
}