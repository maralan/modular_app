import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// A section containing interactive social media icons that link to external platforms.
class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  /// Handles the logic for opening external URLs in the device's default browser or app.
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    // LaunchMode.externalApplication ensures the link opens outside the app context.
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Error abriendo $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          "Síguenos por aquí",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),

        const SizedBox(height: 20),

        /// Uses Wrap to automatically handle line breaks if the icons exceed the screen width.
        Center(
          child: Wrap(
            alignment: WrapAlignment.center, // Centers the icons horizontally within the Wrap.
            spacing: 18, // Horizontal space between individual icons.
            runSpacing: 18, // Vertical space between lines if the icons wrap.
            children: [
              _icon(context, FontAwesomeIcons.facebook, Colors.blue, "https://facebook.com"),
              _icon(context, FontAwesomeIcons.instagram, Colors.purple, "https://instagram.com"),

              /// Adaptive icon for TikTok based on the current theme brightness.
              _icon(
                context,
                FontAwesomeIcons.tiktok,
                isDark ? Colors.white : Colors.black,
                "https://tiktok.com",
              ),

              _icon(context, FontAwesomeIcons.youtube, Colors.red, "https://youtube.com"),
              _icon(context, FontAwesomeIcons.discord, Colors.indigo, "https://discord.com"),

              /// Adaptive icon for X (formerly Twitter).
              _icon(
                context,
                FontAwesomeIcons.xTwitter,
                isDark ? Colors.white : Colors.black,
                "https://twitter.com",
              ),

              _icon(context, FontAwesomeIcons.spotify, Colors.green, "https://spotify.com"),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper method to create a consistent, animated button for each social platform.
  Widget _icon(BuildContext context, IconData icon, Color color, String url) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _openUrl(url),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          /// Background color adapts to the theme to maintain high contrast.
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200],

          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.6)
                  : Colors.grey.withOpacity(0.4),
              blurRadius: 8,
            )
          ],
        ),

        // FontAwesome icon provides the brand-specific glyph.
        child: FaIcon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }
}