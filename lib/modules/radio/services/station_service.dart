import 'dart:convert';

import 'package:http/http.dart'
    as http;

import '../models/station_model.dart';

class StationService {

  Future<List<Station>>
      getStations() async {

    try {

      final response =
          await http.get(

        Uri.parse(
          'https://broadcast.freepi.io/radio/Api/programs_stations/Radio%20by%20Freepi/',
        ),

        headers: {
          "Access-key":
              "2025-RadioByFreepi*6808!?",
        },
      );

      if (response.statusCode !=
          200) {

        print(
          "STATUS ERROR: ${response.statusCode}",
        );

        return [];
      }

      final decoded =
          jsonDecode(response.body);

      //EL API YA ES UNA LISTA
      if (decoded is! List) {

        print(
          "NO ES LISTA",
        );

        return [];
      }

      List<Station> loadedStations =
          [];

      for (var program in decoded) {

        final stations =
            program['stations'];

        if (
            stations == null ||
            stations is! List
        ) {
          continue;
        }

        for (var station in stations) {

          final stream =
              station['station_streaming'];

          if (
              stream == null ||
              !stream
                  .toString()
                  .startsWith('http')
          ) {
            continue;
          }

          loadedStations.add(

            Station(
              name:
                  station['station_frequency'] ??
                  'Radio',

              acronym:
                  station['station_acronym'] ??
                  '',

              streamUrl: stream,

              imageUrl:
                  station['station_image'] ??
                  '',

              slogan:
                  station['station_slogan'] ??
                  '',

              color: null,
            ),
          );
        }
      }

      return loadedStations;

    } catch (e) {

      print(
        "STATION ERROR: $e",
      );

      return [];
    }
  }
}