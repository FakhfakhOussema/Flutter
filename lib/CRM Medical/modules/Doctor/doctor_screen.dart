import 'package:flutter/material.dart';

import '../../layout/drawer.dart';

class DoctorScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:  AppDrawer(),
      appBar: AppBar(
        title:  Text('CRM MEDICAL'),
      ),
      body:  Center(
        child: Text('Doctor Screen',style: TextStyle(fontSize: 50),),
      ),
    );
  }
}
