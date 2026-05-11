import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../helpers/constants.dart';

// A carousel component specialized in displaying advertising or promotional banners.
class PromoCarousel extends StatelessWidget {
  const PromoCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic theme detection to adjust visual depth via shadows.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true, // Automatically slides to ensure all promotions are seen.
        enlargeCenterPage: true, // Enhances the focus on the current promotion.
      ),
      items: promos.map((promo) {
        return GestureDetector(
          // Triggers a custom detail view when the user interacts with the promo.
          onTap: () => _showPromo(context, promo),

          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.6)
                      : Colors.grey.withOpacity(0.4),
                  blurRadius: 10,
                )
              ],
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [

                  /// Promotional background image filling the entire card area.
                  Positioned.fill(
                    child: Image.network(
                      promo.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// Visual overlay using a linear gradient to ensure white text remains readable.
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  /// High-level promotional headline or title.
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: Text(
                      promo.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Displays an informative bottom sheet detailing the promotional offer.
  void _showPromo(BuildContext context, dynamic promo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Essential for content-driven height in modals.
      backgroundColor: Colors.transparent, // Allows for custom card-like shapes.
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min, // Constrains the modal to its children's height.
            children: [

              /// Drag handle UI element for better UX in dismissible sheets.
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// Detailed promotional visual asset.
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(promo.imageUrl),
              ),

              const SizedBox(height: 15),

              /// Primary promotional title in the detail view.
              Text(
                promo.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              /// Detailed description, terms, or conditions of the promotion.
              Text(
                promo.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}