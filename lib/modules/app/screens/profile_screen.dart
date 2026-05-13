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
    final theme = Theme.of(context);
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
                    color: theme.colorScheme.primary.withOpacity(0.12),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 90,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Modo Invitado",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Inicia sesión para sincronizar favoritos, perfil y configuraciones.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
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
              data?['name'] ?? '';

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
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: theme.cardColor,
                        child: Text(
                          nameController.text.isNotEmpty
                            ? nameController.text[0]
                              .toUpperCase()
                            : "U",
                          
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
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
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if ((data?['provider'] ?? '').isNotEmpty)
                        Text(
                          "Proveedor: ${data?['provider']}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),

                      if ((data?['createdAt'] ?? '').isNotEmpty)
                        Text(
                          "Registro: ${data?['createdAt'].toString().split('T')[0]}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),

                      if ((data?['gender'] ?? '').isNotEmpty)
                        Text(
                          "Sexo: ${data?['gender']}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),

                      if ((data?['civilStatus'] ?? '').isNotEmpty)
                        Text(
                          "Estado civil: ${data?['civilStatus']}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                    ],
                  ),
                ).animate().fade().slideY(),

                const SizedBox(height: 30),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Información personal",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 18),

                        if ((data?['gender'] ?? '').isNotEmpty)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.person),
                            title: const Text("Sexo"),
                            subtitle: Text(data?['gender']),
                          ),

                        if ((data?['civilStatus'] ?? '').isNotEmpty)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.favorite),
                            title: const Text("Estado civil"),
                            subtitle:
                                Text(data?['civilStatus']),
                          ),

                        if ((data?['createdAt'] ?? '').isNotEmpty)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.calendar_month),
                            title: const Text("Miembro desde"),
                            subtitle: Text(
                              (data?['createdAt'] ?? '')
                                  .toString()
                                  .split('T')[0],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Editar perfil",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    filled: true,
                    fillColor: theme.cardColor,
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
                      backgroundColor: theme.colorScheme.primary,
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
                        'name':
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

                const SizedBox(height: 10),

                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: theme.colorScheme.primary,
                    ),

                    title: Text(
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
                  color: theme.colorScheme.error.withOpacity(0.08),
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),

                    title: Text(
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
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}