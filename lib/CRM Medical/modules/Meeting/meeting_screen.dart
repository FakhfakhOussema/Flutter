import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/drawer.dart';
import '../../layout/bottomNavBar.dart';
import 'meeting_archived.dart';
import 'meeting_done.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final TextEditingController _doctorController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  int _currentIndex = 0;

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
              const Text(
                'Ajouter un rendez-vous',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// DOCTOR (Dropdown à partir de la collection doctors)
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

              /// DATE + HEURE (TextField cliquable)
              GestureDetector(
                onTap: () async {
                  // 1️⃣ Sélection de la date
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    // 2️⃣ Sélection de l'heure
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

                        // Affichage date + heure dans le TextField
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
                      labelText: 'Date et heure prévues',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// SAVE
              ElevatedButton(
                onPressed: () async {
                  // Vérification que tous les champs sont remplis
                  if (_doctorController.text.trim().isEmpty || _selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez remplir tous les champs'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // Ajout du rendez-vous dans Firestore
                    await FirebaseFirestore.instance.collection('meetings').add({
                      'doctor': _doctorController.text.trim(),
                      'date': Timestamp.fromDate(_selectedDate!),
                      'status': 0, // statut : programmé
                    });

                    // Fermeture du modal
                    Navigator.pop(context);

                    // Réinitialisation des champs
                    _doctorController.clear();
                    _dateController.clear();
                    setState(() => _selectedDate = null);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rendez-vous ajouté avec succès'),
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
                child: const Text(
                  'Ajouter',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )

            ],
          ),
        );
      },
    );
  }



  /// BOTTOM NAVIGATION
  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MeetingDone()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MeetingArchived()),
      );
    }
  }

  @override
  void dispose() {
    _doctorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Meetings'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('meetings')
            .where('status', isEqualTo: 0)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Aucun rendez-vous',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((doc) {
              final Timestamp ts = doc['date'];
              final DateTime date = ts.toDate();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.blue),
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
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('meetings')
                              .doc(doc.id)
                              .update({'status': 1});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.archive, color: Colors.grey),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('meetings')
                              .doc(doc.id)
                              .update({'status': 2});
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
