import 'package:flutter/material.dart';

import '../../layout/appBar.dart';
import '../../layout/drawer.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: customAppBar(title: 'Home'),
      body: const Center(
        child: Text('Home Screen',style: TextStyle(fontSize: 50),),
      ),
    );
  }
}
