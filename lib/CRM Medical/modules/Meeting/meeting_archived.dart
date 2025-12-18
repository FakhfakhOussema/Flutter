import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../layout/appBar.dart';
import '../../layout/bottomNavBar.dart';
import '../../layout/drawer.dart';
import 'meeting_done.dart';
import 'meeting_screen.dart';

class MeetingArchived extends StatefulWidget {
  const MeetingArchived({super.key});

  @override
  State<MeetingArchived> createState() => _MeetingArchivedState();
}

class _MeetingArchivedState extends State<MeetingArchived> {
  int _currentIndex = 2; // Archived

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MeetingScreen()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MeetingDone()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Archived Meetings'),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('meetings')
            .where('status', isEqualTo: 2)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Aucun rendez-vous archivé',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final date = (doc['date'] as Timestamp).toDate();

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.archive,
                    color: Colors.grey,
                  ),
                  title: Text(
                    doc['doctor'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${date.day.toString().padLeft(2, '0')}/'
                        '${date.month.toString().padLeft(2, '0')}/'
                        '${date.year} à '
                        '${date.hour.toString().padLeft(2, '0')}:'
                        '${date.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // RESTORE
                      IconButton(
                        icon: const Icon(Icons.restore, color: Colors.blue),
                        tooltip: 'Restaurer',
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('meetings')
                              .doc(doc.id)
                              .update({'status': 0});
                        },
                      ),

                      // DELETE
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Supprimer',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text(
                                'Voulez-vous vraiment supprimer ce rendez-vous ?',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Annuler'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Supprimer'),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('meetings')
                                        .doc(doc.id)
                                        .delete();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
