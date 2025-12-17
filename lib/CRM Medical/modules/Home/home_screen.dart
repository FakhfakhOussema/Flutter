import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Home'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            const Text(
              'Bienvenue 👋',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Gérez facilement vos rendez-vous médicaux',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // Stat Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                _StatCard(
                  title: 'Meetings',
                  value: '12',
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                ),
                _StatCard(
                  title: 'Doctors',
                  value: '5',
                  icon: Icons.medical_services,
                  color: Colors.green,
                ),
                _StatCard(
                  title: 'Completed',
                  value: '8',
                  icon: Icons.check_circle,
                  color: Colors.orange,
                ),
                _StatCard(
                  title: 'Archived',
                  value: '3',
                  icon: Icons.archive,
                  color: Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Quick Actions
            const Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.add,
                  label: 'Nouveau RDV',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(context, '/meeting');
                  },
                ),
                _ActionButton(
                  icon: Icons.person_add,
                  label: 'Docteur',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(context, '/doctors');
                  },
                ),
                _ActionButton(
                  icon: Icons.medication,
                  label: 'Médicament',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pushNamed(context, '/Medication');
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Recent meetings
            const Text(
              'Derniers rendez-vous',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _RecentMeetingTile(
              doctor: 'Dr. Ahmed',
              date: '12/01/2025',
            ),
            _RecentMeetingTile(
              doctor: 'Dr. Salma',
              date: '10/01/2025',
            ),
          ],
        ),
      ),
    );
  }
}


class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}


class _RecentMeetingTile extends StatelessWidget {
  final String doctor;
  final String date;

  const _RecentMeetingTile({
    required this.doctor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.blue),
        title: Text(doctor),
        subtitle: Text('Date : $date'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}




