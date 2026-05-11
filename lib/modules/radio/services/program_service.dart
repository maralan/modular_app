import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/program_model.dart';

class ProgramService {

  Future<List<Program>> getPrograms() async {

    try {

      final response = await http.get(
        Uri.parse(
          'https://broadcast.freepi.io/radio/Api/programs_company_pagination/Radio%20by%20Freepi/10',
        ),
      );

      if (response.statusCode != 200) {
        print("STATUS ERROR: ${response.statusCode}");
        return [];
      }

      final decoded = jsonDecode(response.body);

      final programsData = decoded['results'];

      if (programsData == null) {
        print("RESULTS VIENE NULL");
        return [];
      }

      if (programsData is! List) {
        print("RESULTS NO ES LIST");
        return [];
      }

      return programsData
          .map<Program>((e) {
            return Program.fromJson(
              Map<String, dynamic>.from(e),
            );
          })
          .toList();

    } catch (e) {

      print("PROGRAM ERROR: $e");

      return [];
    }
  }
}