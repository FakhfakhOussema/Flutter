import 'package:flutter/material.dart';

import '../../layout/drawer.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('CRM MEDICAL'),
      ),
      body: const Center(
        child: Text('Home Screen',style: TextStyle(fontSize: 50),),
      ),
    );
  }
}
