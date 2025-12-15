import 'package:flutter/material.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Done Tasks',
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
