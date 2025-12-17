import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/drawer.dart';
import '../../layout/bottomNavBar.dart';
import 'meeting_archived.dart';
import 'meeting_done.dart'; // chemin vers ton bottomNavBar

class MeetingScreen extends StatefulWidget {
  MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final TextEditingController _doctorController = TextEditingController();
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _doctorController,
                decoration: const InputDecoration(
                  labelText: 'Nom du docteur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Aucune date sélectionnée'
                          : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: const Text('Choisir une date'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_doctorController.text.isEmpty || _selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez remplir tous les champs'),
                      ),
                    );
                    return;
                  }

                  // Logique d'ajout de rendez-vous
                  print('Docteur: ${_doctorController.text}');
                  print('Date: $_selectedDate');

                  Navigator.pop(context);
                  _doctorController.clear();
                  _selectedDate = null;
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MeetingDone()),
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
      appBar: customAppBar(title: 'Meetings'),
      body: const Center(
        child: Text(
          'Meeting Screen',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMeetingModal(context),
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, size: 30, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
