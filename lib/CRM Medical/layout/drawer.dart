import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.blue),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.email ?? 'Utilisateur',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          drawerItem(
            context,
            title: 'Home',
            icon: Icons.home,
            route: "/home",
          ),
          drawerItem(
            context,
            title: 'Doctors',
            icon: Icons.medical_services,
            route: '/doctors',
          ),
          drawerItem(
            context,
            title: 'Medication',
            icon: Icons.medication,
            route: "/Medication",
          ),
          drawerItem(
            context,
            title: 'Meeting', // Nouvel item pour les RDV
            icon: Icons.calendar_today,
            route: "/meeting",
          ),
          drawerItem(
            context,
            title: 'Settings',
            icon: Icons.settings_outlined,
            route: '/Seetings',
          ),
          ListTile(
            title: const Text('Déconnexion', style: TextStyle(fontSize: 18)),
            leading: const Icon(Icons.logout, color: Colors.blue),
            trailing: const Icon(Icons.arrow_right, color: Colors.blue),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/Login',
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget drawerItem(BuildContext context,
    {required String title,
      required IconData icon,
      required String route}) {
  return Column(
    children: [
      ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        leading: Icon(icon, color: Colors.blue),
        trailing: const Icon(Icons.arrow_right, color: Colors.blue),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      ),
      const Divider(height: 4, color: Colors.blue),
    ],
  );
}
