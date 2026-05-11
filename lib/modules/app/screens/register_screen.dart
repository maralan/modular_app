import 'package:flutter/material.dart';
import 'package:modular_app/modules/app/provider/favorites_provider.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../../../utils/validators.dart';

import 'package:flutter_animate/flutter_animate.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<RegisterScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  final formKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final auth =
        Provider.of<AuthProvider>(context);

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [

              Color(0xFF12324A),

              Color(0xFF1E5878),

              Color(0xFFF4F7FB),
            ],
          ),
        ),

        child: Center(

          child: SingleChildScrollView(

            padding:
                const EdgeInsets.all(24),

            child: Container(

              padding:
                  const EdgeInsets.all(24),

              decoration: BoxDecoration(

                color:
                    isDark
                        ? Colors.grey[900]
                        : Colors.white,

                borderRadius:
                    BorderRadius.circular(28),

                boxShadow: [

                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.12),

                    blurRadius: 20,

                    offset:
                        const Offset(0, 10),
                  ),
                ],
              ),

              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.radio,
                      size: 70,
                      color: Color(0xFF12324A),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Freepi App",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextFormField(

                      controller:
                          emailController,

                      decoration:
                          InputDecoration(

                        labelText: "Email",

                        prefixIcon:
                            const Icon(
                          Icons.email,
                        ),

                        filled: true,

                        fillColor:
                            isDark
                                ? Colors.grey[850]
                                : Colors.grey[100],

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),

                      validator: (value) =>
                          Validators.email(
                        value ?? "",
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller:
                          passwordController,
                      obscureText: true,
                      decoration:
                          InputDecoration(
                        labelText: "Password",
                        prefixIcon:
                            const Icon(
                          Icons.lock,
                        ),

                        filled: true,
                        fillColor:
                            isDark
                                ? Colors.grey[850]
                                : Colors.grey[100],
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          borderSide:
                              BorderSide.none,
                        ),
                      ),

                      validator: (value) =>
                          Validators.password(
                        value ?? "",
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller:
                          confirmController,
                      obscureText: true,
                      decoration:
                          InputDecoration(
                        labelText:
                            "Confirmar contraseña",
                        prefixIcon:
                            const Icon(
                          Icons.lock_outline,
                        ),
                        filled: true,
                        fillColor:
                            isDark
                                ? Colors.grey[850]
                                : Colors.grey[100],
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value !=
                            passwordController.text) {
                          return
                              "Las contraseñas no coinciden";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    if (auth.errorMessage != null)

                      Padding(

                        padding:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: Text(

                          auth.errorMessage!,

                          style:
                              const TextStyle(
                            color: Colors.red,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                    SizedBox(

                      width: double.infinity,

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              const Color(
                            0xFF12324A,
                          ),

                          foregroundColor:
                              Colors.white,

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 16,
                          ),

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                        ),

                        onPressed:
                            auth.isLoading
                                ? null
                                : () async {
                                    if (!formKey
                                        .currentState!
                                        .validate()) {
                                      return;
                                    }
                                    await auth.register(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                    await context
                                        .read<FavoritesProvider>()
                                        .loadAllFavorites();
                                    if (auth.user != null && context.mounted) {
                                      Navigator.pushReplacementNamed(
                                        context, 
                                        '/home'
                                      );
                                    }
                                  },
                                  
                        child:
                            auth.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child:
                                        CircularProgressIndicator(
                                      color:
                                          Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
                                    "Registrarse",
                                  ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Text(
                        "¿Ya tienes cuenta? Inicia sesión",
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fade(duration: 500.ms)
                .slideY(begin: 0.1),
          ),
        ),
      ),
    );
  }
}