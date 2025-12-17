import 'package:flutter/material.dart';

import '../../layout/drawer.dart';

class MeetingScreen extends StatelessWidget {
  MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('CRM MEDICAL'),
      ),
      body: const Center(
        child: Text('Metting Screen',style: TextStyle(fontSize: 50),),
      ),
    );
  }
}
