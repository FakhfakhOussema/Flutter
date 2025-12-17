import 'package:flutter/material.dart';

import '../../layout/appBar.dart';
import '../../layout/drawer.dart';

class SeetingScreen extends StatelessWidget {
  const SeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:  AppDrawer(),
      appBar: customAppBar(title: 'Seetings'),
      body:  Center(
        child: Text('Seeting Screen',style: TextStyle(fontSize: 50),),
      ),
    );
  }
}
