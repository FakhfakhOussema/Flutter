import 'package:app_examen/CRM%20Medical/modules/Meeting/meeting_screen.dart';
import 'package:flutter/material.dart';
import '../../layout/appBar.dart';
import '../../layout/bottomNavBar.dart';
import '../../layout/drawer.dart';
import 'meeting_archived.dart';

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
      body: const Center(
        child: Text(
          'Meeting Done',
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
