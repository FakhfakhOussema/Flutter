import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/drawer.dart';
import '../Meeting/meeting_archived.dart';
import '../Meeting/meeting_done.dart';
import '../Meeting/meeting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Compter les documents d'une collection ou avec filtre
  Stream<int>? _countDocuments(String collection, {Map<String, dynamic>? where}) {
    Stream<QuerySnapshot>? stream;
    if (where != null) {
      where.forEach((key, value) {
        stream = FirebaseFirestore.instance
            .collection(collection)
            .where(key, isEqualTo: value)
            .snapshots();
      });
    } else {
      stream = FirebaseFirestore.instance.collection(collection).snapshots();
    }
    return stream?.map((snap) => snap.size);
  }

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
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Easily manage your medical appointments',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 25),

            // Stat Cards dynamiques
            StreamBuilder<int>(
              stream: FirebaseFirestore.instance
                  .collection('meetings')
                  .snapshots()
                  .map((snap) => snap.size),
              builder: (context, snapshot) {
                final meetingsCount = snapshot.data ?? 0;
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _StatCard(
                      title: 'All Meetings',
                      value: meetingsCount.toString(),
                      icon: Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    StreamBuilder<int>(
                      stream: FirebaseFirestore.instance
                          .collection('meetings')
                          .where('status', isEqualTo: 0) // status = 0 => Scheduled / Meetings
                          .snapshots()
                          .map((snap) => snap.size),
                      builder: (context, snapScheduled) {
                        final scheduledCount = snapScheduled.data ?? 0;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MeetingScreen()),
                            );
                          },
                          child: _StatCard(
                            title: 'Scheduled',
                            value: scheduledCount.toString(),
                            icon: Icons.schedule, // icône pour Meetings
                            color: Colors.blue,
                          ),
                        );
                      },
                    ),
                    StreamBuilder<int>(
                      stream: FirebaseFirestore.instance
                          .collection('meetings')
                          .where('status', isEqualTo: 1) // status = 1 => Done
                          .snapshots()
                          .map((snap) => snap.size),
                      builder: (context, snapDone) {
                        final doneCount = snapDone.data ?? 0;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MeetingDone()),
                            );
                          },
                          child: _StatCard(
                            title: 'Done',
                            value: doneCount.toString(),
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        );
                      },
                    ),
                    StreamBuilder<int>(
                      stream: FirebaseFirestore.instance
                          .collection('meetings')
                          .where('status', isEqualTo: 2) // status = 2 => Archived
                          .snapshots()
                          .map((snap) => snap.size),
                      builder: (context, snapArchived) {
                        final archivedCount = snapArchived.data ?? 0;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MeetingArchived()),
                            );
                          },
                          child: _StatCard(
                            title: 'Archived',
                            value: archivedCount.toString(),
                            icon: Icons.archive,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),



                  ],
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Quick actions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.add,
                  label: 'New Appointment',
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, '/meeting'),
                ),
                _ActionButton(
                  icon: Icons.person_add,
                  label: 'Doctor',
                  color: Colors.green,
                  onTap: () => Navigator.pushNamed(context, '/doctors'),
                ),
                _ActionButton(
                  icon: Icons.medication,
                  label: 'Medication',
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/Medication'),
                ),
              ],
            ),

            const SizedBox(height: 25),
            const Text(
              'Recent Appointments',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

// Liste des derniers meetings (status = 0 ou active)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('meetings')
                  .limit(3) // <-- ici on limite à 3
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucun rendez-vous récent'));
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final Timestamp ts = doc['date'];
                    final DateTime date = ts.toDate();
                    return _RecentMeetingTile(
                      doctor: doc['doctor'],
                      date:
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                    );
                  }).toList(),
                );
              },
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
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(color: Colors.grey)),
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
