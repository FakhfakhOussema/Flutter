import 'package:flutter/material.dart';

import '../../layout/appBar.dart';
import '../../layout/drawer.dart';

class DoctorScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:  AppDrawer(),
      appBar: customAppBar(title: 'Doctors'),
      body:  Center(
        child: Text('Doctor Screen',style: TextStyle(fontSize: 50),),
      ),
    );
  }
}
