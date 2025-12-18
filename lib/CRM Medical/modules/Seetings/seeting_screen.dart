import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(user?.displayName ?? 'USER'),
                subtitle: Text(user?.email ?? 'email@example.com'),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  // Plus tard : modification profil
                },
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('Dark mode'),
                secondary: const Icon(Icons.dark_mode),
                value: _darkMode,
                onChanged: (val) {
                  setState(() {
                    _darkMode = val;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            // Notification
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('Notifications'),
                secondary: const Icon(Icons.notifications),
                value: _notifications,
                onChanged: (val) {
                  setState(() {
                    _notifications = val;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18),
                ),
                leading: const Icon(Icons.logout, color: Colors.red),
                trailing: const Icon(Icons.arrow_right, color: Colors.red),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/Login',
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
