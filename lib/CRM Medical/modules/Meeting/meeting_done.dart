import 'package:app_examen/CRM%20Medical/modules/Meeting/meeting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/bottomNavBar.dart';
import '../../layout/drawer.dart';
import 'meeting_archived.dart';
import 'meeting_screen.dart';

class MeetingDone extends StatefulWidget {
  const MeetingDone({super.key});

  @override
  State<MeetingDone> createState() => _MeetingDoneState();
}

class _MeetingDoneState extends State<MeetingDone> {
  int _currentIndex = 1; // Completed

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MeetingScreen()),
      );
    }
    if(index==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MeetingArchived()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Completed Meetings'),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('meetings')
            .where('status', isEqualTo: 1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No completed appointments',
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
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.archive, color: Colors.grey),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('meetings')
                          .doc(doc.id)
                          .update({'status': 2});
                    },
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
