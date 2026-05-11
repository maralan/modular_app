class Validators {
  static String? email(String value) {
    if (value.isEmpty) return "El email es obligatorio";

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return "Email no válido";

    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return "La contraseña es obligatoria";
    if (value.length < 8) return "Mínimo 8 caracteres";
    return null;
  }
}