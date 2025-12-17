import 'package:flutter/material.dart';

import '../../layout/appBar.dart';
import '../../layout/drawer.dart';

class MedicationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  AppDrawer(),
      appBar: customAppBar(title: 'Medications'),
      body:  Center(
        child: Text('Medication Screen',style: TextStyle(fontSize: 50),),
      ),
    );
  }
}



