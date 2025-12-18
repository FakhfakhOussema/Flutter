import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/drawer.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paramètres',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Compte utilisateur
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text('Nom utilisateur'),
                subtitle: const Text('email@example.com'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Ajouter logique pour modifier le compte
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Thème sombre
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                title: const Text('Mode sombre'),
                secondary: const Icon(Icons.dark_mode),
                value: _darkMode,
                onChanged: (val) {
                  setState(() {
                    _darkMode = val;
                  });
                  // Ajouter logique pour changer le thème global
                },
              ),
            ),
            const SizedBox(height: 10),

            // Notifications
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                title: const Text('Notifications'),
                secondary: const Icon(Icons.notifications),
                value: _notifications,
                onChanged: (val) {
                  setState(() {
                    _notifications = val;
                  });
                  // Ajouter logique pour activer/désactiver notifications
                },
              ),
            ),
            const SizedBox(height: 20),

            // Déconnexion
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Déconnexion'),
                onPressed: () {
                  // Ajouter logique pour logout
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
