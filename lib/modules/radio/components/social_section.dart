import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// A section containing interactive social media icons that link to external platforms.
class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Error abriendo $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          "Síguenos por aquí",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),

        const SizedBox(height: 20),

        /// Uses Wrap to automatically handle line breaks if the icons exceed the screen width.
        Center(
          child: Wrap(
            alignment: WrapAlignment.center, // Centers the icons horizontally within the Wrap.
            spacing: 18,
            runSpacing: 18, // Vertical space between lines if the icons wrap.
            children: [
              _icon(context, FontAwesomeIcons.facebook, Colors.blue, "https://facebook.com"),
              _icon(context, FontAwesomeIcons.instagram, Colors.purple, "https://instagram.com"),

              /// Adaptive icon for TikTok based on the current theme brightness.
              _icon(
                context,
                FontAwesomeIcons.tiktok,
                theme.iconTheme.color ?? Colors.white,
                "https://tiktok.com",
              ),

              _icon(context, FontAwesomeIcons.youtube, Colors.red, "https://youtube.com"),
              _icon(context, FontAwesomeIcons.discord, Colors.indigo, "https://discord.com"),

              /// Adaptive icon for X (formerly Twitter).
              _icon(
                context,
                FontAwesomeIcons.xTwitter,
                theme.iconTheme.color ?? Colors.white,
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _openUrl(url),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          /// Background color adapts to the theme to maintain high contrast.
          color: theme.cardColor,

          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3)
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