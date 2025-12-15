import 'package:flutter/material.dart';

class MessangerScreen extends StatelessWidget {
  const MessangerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: 20,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
            ),
            SizedBox(width: 5,),
            Text (
              'Chats',
              style: TextStyle(color:Colors.black),

            )
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blue,
              child: Icon(
                  Icons.camera_alt,
                size: 16,
                color: Colors.white,
              )
          )),
          IconButton(onPressed: (){}, icon: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.edit,
                size: 16,
                color: Colors.white,
              )
          )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[300],
                  ),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 15,),
                      Text('Search')
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index)=>buildStoryItem(),
                    separatorBuilder: (context,index)=>SizedBox(width: 20),
                    itemCount: 10,
                  ),
                ),
                SizedBox(height: 10),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemBuilder: (context,index)=>buildChatItem(),
                    separatorBuilder: (context,index)=>SizedBox(height: 20,),
                    itemCount: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStoryItem() => Container(
    width: 60,
    child: Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                bottom: 5,
                end : 3,
              ),
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),
        Text('Oussema Fakhfakh',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ),
  );
  Widget buildChatItem()  => Row(
    children: [
      Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: 5,
              end : 3,
            ),
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      SizedBox(width: 20,),
      Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Oussema Fakhfakh Oussema Fakhfakh Oussema Fakhfakh',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize:16,fontWeight: FontWeight.bold ),
              ),
              Row(
                children: [
                  Expanded(child: Text('Message de test Message de test Message de test Message de test Message de test Message de test ',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Text('2:00 pm'),
                ],
              ),
            ]
        ),

      )
    ],
  );

}
