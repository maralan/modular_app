import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import '../provider/auth_provider.dart' as local;

import 'login_screen.dart';
import '../provider/theme_provider.dart';

import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = FirebaseAuth.instance.currentUser;

    final auth =
        Provider.of<local.AuthProvider>(
      context,
      listen: false,
    );

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey
                        .withOpacity(0.12),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 90,
                    color: Color(0xFF12324A),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Modo Invitado",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Inicia sesión para sincronizar favoritos, perfil y configuraciones.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35),

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
                          16,
                        ),
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      "Iniciar sesión",
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                OutlinedButton(
                  style:
                      OutlinedButton.styleFrom(
                    minimumSize:
                        const Size.fromHeight(55),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LoginScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    "Registrarse",
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>?;

          nameController.text =
              data?['displayName'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                const SizedBox(height: 20),

                

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: 
                      BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF12324A),
                        Color(0xFF1E5878),
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white,
                        child: Text(
                          nameController.text.isNotEmpty
                            ? nameController.text[0]
                              .toUpperCase()
                            : "U",
                          
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF12324A),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        nameController.text.isNotEmpty
                          ? nameController.text
                          : "Usuario",
                        
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        data?['email'] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "UID: ${user.uid}",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ).animate().fade().slideY(),

                const SizedBox(height: 30),

                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {

                    return Card(
                      child: SwitchListTile(
                        value: themeProvider.isDarkMode,

                        title: const Text("Modo oscuro"),

                        secondary: const Icon(
                          Icons.dark_mode,
                        ),

                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      ),
                    );
                  },
                ),

                TextField(
                  controller: nameController,

                  decoration: InputDecoration(
                    labelText: "Nombre",

                    filled: true,

                    fillColor:
                        isDark
                            ? Colors.grey[900]
                            : Colors.grey[200],

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF12324A),
                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: () async {

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                        'displayName':
                            nameController.text,
                      });

                      if (!mounted) return;

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Perfil actualizado",
                          ),
                        ),
                      );
                    },

                    child: const Text(
                      "Guardar cambios",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  child: ListTile(

                    leading: const Icon(
                      Icons.notifications,
                      color: Color(0xFF12324A),
                    ),

                    title: const Text(
                      "Notificaciones",
                    ),

                    subtitle: const Text(
                      "Firebase Messaging activo",
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Color(0xFF12324A),
                    ),

                    title: const Text(
                      "Cerrar sesión",
                    ),

                    onTap: () async {
                      await auth.logout();
                      if (!mounted) return;
                        
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen(),
                        ), 
                        (route) => false,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),

                    title: const Text(
                      "Eliminar cuenta",
                    ),

                    onTap: () async {

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .delete();

                      await user.delete();

                      if (!mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen(),
                        ),

                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}