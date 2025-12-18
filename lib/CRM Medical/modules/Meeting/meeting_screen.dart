import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/drawer.dart';
import '../../layout/bottomNavBar.dart';
import 'meeting_archived.dart';
import 'meeting_done.dart';
import '../notification/meeting_notification_service.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  int _currentIndex = 0;

  /// BOUTON BOTTOM NAVIGATION
  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MeetingDone()));
    }
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MeetingArchived()));
    }
  }

  /// MODAL D’AJOUT D’UN MEETING
  void _showAddMeetingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ajouter un rendez-vous', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              /// DOCTOR (Dropdown à partir de Firestore)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  List<DropdownMenuItem<String>> items = snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc['name'],
                      child: Text(doc['name']),
                    );
                  }).toList();
                  return DropdownButtonFormField<String>(
                    value: _doctorController.text.isEmpty ? null : _doctorController.text,
                    items: items,
                    decoration: const InputDecoration(
                      labelText: 'Doctor',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _doctorController.text = value!;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              /// DATE + HEURE
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _dateController.text =
                        '${pickedDate.day.toString().padLeft(2, '0')}/'
                            '${pickedDate.month.toString().padLeft(2, '0')}/'
                            '${pickedDate.year} '
                            '${pickedTime.hour.toString().padLeft(2, '0')}:'
                            '${pickedTime.minute.toString().padLeft(2, '0')}';
                      });
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Scheduled Date and Time',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// BOUTON AJOUTER
              ElevatedButton(
                onPressed: () async {
                  if (_doctorController.text.trim().isEmpty || _selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  try {
                    await FirebaseFirestore.instance.collection('meetings').add({
                      'doctor': _doctorController.text.trim(),
                      'date': Timestamp.fromDate(_selectedDate!),
                      'status': 0,
                    });
                    Navigator.pop(context);
                    _doctorController.clear();
                    _dateController.clear();
                    setState(() => _selectedDate = null);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Appointment added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur lors de l\'ajout : $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blue[700],
                ),
                child: const Text('Add', style: TextStyle(fontSize: 16, color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _doctorController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Meetings'),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('meetings').where('status', isEqualTo: 0).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Appointments', style: TextStyle(fontSize: 18)),
            );
          }

          // Notifications + vibration pour meetings < 1 min
          MeetingNotificationService.checkMeetings(snapshot.data!);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((doc) {
              final Timestamp ts = doc['date'];
              final DateTime date = ts.toDate();
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.blue),
                  title: Text(doc['doctor'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${date.day.toString().padLeft(2, '0')}/'
                        '${date.month.toString().padLeft(2, '0')}/'
                        '${date.year} '
                        '${date.hour.toString().padLeft(2, '0')}:'
                        '${date.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          FirebaseFirestore.instance.collection('meetings').doc(doc.id).update({'status': 1});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.archive, color: Colors.grey),
                        onPressed: () {
                          FirebaseFirestore.instance.collection('meetings').doc(doc.id).update({'status': 2});
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMeetingModal(context),
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
