import 'package:flutter/material.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Archived Tasks',
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
