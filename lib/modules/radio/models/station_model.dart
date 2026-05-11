import 'package:flutter/material.dart';

class Station {
  final String name;
  final String acronym;
  final String streamUrl;
  final String imageUrl;
  final String slogan;
  final Color? color;

  Station({
    required this.name,
    required this.acronym,
    required this.streamUrl,
    required this.imageUrl,
    required this.slogan,
    this.color,
  });

  factory Station.fromJson(
    Map<String, dynamic> json,
  ) {

    return Station(
      name:
          json['radio_name'] ?? '',
      acronym:
          json['radio_acronym'] ?? '',
      streamUrl:
          json['stream_url'] ?? '',
      imageUrl:
          json['radio_cover'] ?? '',
      slogan:
          json['radio_slogan'] ?? '',
      color: Colors.blueGrey,
    );
  }
}