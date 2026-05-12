import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/station_provider.dart';

import '../provider/audio_provider.dart';
import '../provider/program_provider.dart';

import '../components/program_carousel.dart';
import '../components/station_card.dart';
import '../components/promo_carousel.dart';
import '../components/social_section.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RadioHomeScreen extends StatefulWidget {
  const RadioHomeScreen({super.key});

  @override
  State<RadioHomeScreen> createState() =>
      _RadioHomeScreenState();
  }

  class _RadioHomeScreenState
      extends State<RadioHomeScreen>
      with AutomaticKeepAliveClientMixin {
    
    @override
      bool get wantKeepAlive => true;

    @override
    void initState() {
      super.initState();
      final programProvider =
        context.read<ProgramProvider>();

      final stationProvider = context.read<StationProvider>();
      final audioProvider = context.read<AudioProvider>();

      Future.microtask(() async {
        await programProvider.loadPrograms();
        await stationProvider.loadStations();

        if (!mounted) return;

        final stations =
            stationProvider.stations;

        if (stations.isNotEmpty) {
          audioProvider.setStations(stations);
        }
      });
    }

    @override
    Widget build(BuildContext context) {

      super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Builder(
        builder: (context) {
          final stationProvider =
              context.watch<StationProvider>();
          final isLoading =
              context.watch<AudioProvider>()
                  .isLoading;

          if (stationProvider.isLoading) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (stationProvider.stations.isEmpty) {

            return const Center(
              child: Text(
                "No hay estaciones",
              ),
            );
          }

          final mainStation =
            context.select<AudioProvider, dynamic>(
              (provider) =>
                  provider.currentStation,
            ) ??
            stationProvider.stations.first;

          return SingleChildScrollView(
            child: Padding(
              // Quitamos el top padding excesivo de aquí porque el AppBar ya tendrá el suyo
              padding: const EdgeInsets.only(top: 10), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 20, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          "Nuestras",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Estaciones",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Featured station card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        StationCard(
                          station: mainStation,
                        )
                        .animate()
                        .fade(
                          duration: 500.ms,
                        )
                        .scale(
                          begin: const Offset(0.95, 0.95)
                        ),
                        if (isLoading)
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ... Resto de tu código (Carousel, Programas, etc.) se mantiene igual
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 110,
                        enlargeCenterPage: true,
                        viewportFraction: 0.35,
                        enableInfiniteScroll: false,
                      ),
                      items: stationProvider.stations.map((station) {
                        return Builder(
                          builder: (context) {
                            
                            final isActive = context.select<AudioProvider, bool>(
                              (provider) => 
                                  provider.currentStation
                                      ?.streamUrl ==
                                  station.streamUrl,
                            );

                            return GestureDetector(
                              onTap: () => context
                                  .read<AudioProvider>()
                                  .playStation(station),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isActive ? Colors.yellow : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: isActive ? 40 : 32,
                                  backgroundImage: NetworkImage(station.imageUrl),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Título Programas
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          "Nuestros",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Programas",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ProgramCarousel(),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Promociones y Eventos",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const PromoCarousel(),
                  const SizedBox(height: 20),
                  const SocialSection(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}