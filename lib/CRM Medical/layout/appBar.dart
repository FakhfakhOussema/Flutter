import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar({String title = 'CRM MEDICAL'}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 22,
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.blue[700],
    elevation: 4,
    centerTitle: true,
  );
}
