import 'package:flutter/material.dart';

import '../models/station_model.dart';
import '../models/program_model.dart';
import '../models/promo_model.dart';

// List of available radio stations with their respective streaming metadata.
final stations = [
  Station(
    name: "Live Jazz Radio",
    acronym: "LJR",
    // Source URL for the audio stream.
    streamUrl: "https://stream.freepi.io/8012/live",
    imageUrl: "https://cloud.freepi.io/enterprise/Radioactiva_Tx/stations/LIVEJAZZ_RADIO_-_CDMX.webp",
    slogan: "La síncopa de nuestras latitudes",
    // Main color used for UI elements related to this station.
    color: Colors.blueGrey,
  ),
  Station(
    name: "Radioactiva Tx",
    acronym: "RTX",
    streamUrl: "https://stream.freepi.io/8010/stream",
    imageUrl: "https://cloud.freepi.io/enterprise/Radioactiva_Tx/stations/image_2024-04-04_192330024.webp",
    slogan: "¡La Radio Alternativa!",
    color: Colors.yellow,
  ),
];

// List of radio programs to be displayed in the schedule or featured sections.
final programs = [
  Program(
    title: "NOTICIERO NCC",
    description: "Noticias relevantes del día",
    imageUrl: "https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0",
    day: "Martes",
    startTime: "09:30 AM",
    endTime: "10:00 AM",
  ),
  Program(
    title: "PROGRESIÓN",
    description: "Música progresiva",
    imageUrl: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f",
    day: "Martes",
    startTime: "12:00 PM",
    endTime: "01:00 PM",
  ),
  Program(
    title: "JAZZ NIGHT",
    description: "Jazz relajante",
    imageUrl: "https://images.unsplash.com/photo-1511379938547-c1f69419868d",
    day: "Miércoles",
    startTime: "08:00 PM",
    endTime: "10:00 PM",
  ),
];

// List of promotional banners and special events for the home screen carousel.
final promos = [
  Promo(
    title: "Festival en vivo",
    imageUrl: "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
    description: "Concierto en vivo este fin de semana 🔥",
  ),
  Promo(
    title: "Cabina de radio",
    imageUrl: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4",
    description: "Transmisión especial desde cabina 🎧",
  ),
  Promo(
    title: "DJ Session",
    imageUrl: "https://images.unsplash.com/photo-1470225620780-dba8ba36b745",
    description: "Sesión exclusiva con DJ invitado 🎶",
  ),
  Promo(
    title: "Entrevista",
    imageUrl: "https://images.unsplash.com/photo-1521336575822-6da63fb45455",
    description: "Invitado especial esta semana 🎤",
  ),
  Promo(
    title: "Noche electrónica",
    imageUrl: "https://images.unsplash.com/photo-1506157786151-b8491531f063",
    description: "Especial música electrónica 🌙",
  ),
];