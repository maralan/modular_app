class Promo {
  // The headline or name of the promotion or special event.
  final String title;

  // The web URL for the promotional banner or background image.
  final String imageUrl;

  // Detailed information regarding the promotion or event details.
  final String description;

  // Constructor requiring all properties to be provided when creating a new instance.
  Promo({
    required this.title,
    required this.imageUrl,
    required this.description,
  });
}