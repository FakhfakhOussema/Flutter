import 'package:flutter/material.dart';

import '../../models/user/user_model.dart';


class UsersScreen extends StatelessWidget {
  List<UserModel> users = [
    UserModel(
        id: 1, name: 'Oussema Fakhfakh', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 2, name: 'Eya Sahnoun', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 3, name: 'Ala Elloumi', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 4, name: 'Khouloud Sadallah', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 5, name: 'Oussema Fakhfakh', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 6, name: 'Eya Sahnoun', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 7, name: 'Ala Elloumi', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 8, name: 'Khouloud Sadallah', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 9, name: 'Oussema Fakhfakh', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 10, name: 'Eya Sahnoun', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 11, name: 'Ala Elloumi', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 12, name: 'Khouloud Sadallah', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 13, name: 'Oussema Fakhfakh', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 14, name: 'Eya Sahnoun', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 15, name: 'Ala Elloumi', phone: '+216 25 059 833'
    ),
    UserModel(
        id: 16, name: 'Khouloud Sadallah', phone: '+216 25 059 833'
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users',
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body:ListView.separated(
          itemBuilder: (context,index)=>buildUserItem(users[index]),
          separatorBuilder: (context,index)=>Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Container(
              width:double.infinity,
              height: 1,
              color: Colors.grey[400],
            ),
          ),
          itemCount: users.length),
    );
  }

  Widget buildUserItem(UserModel user) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children:[
        CircleAvatar(
          radius: 25,
          child: Text(
            '${user.id}',
            style:
            TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 20,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${user.name}',
              style:
              TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${user.phone}',
              style:
              TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    ),
  );
}
