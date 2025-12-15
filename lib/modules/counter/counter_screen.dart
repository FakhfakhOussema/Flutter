import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('App',style:TextStyle(color: Colors.white) ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed:(){
              setState(() {
                counter--;
              });
              }, child: Text('Minus',style: TextStyle(color: Colors.red),)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('$counter',style:TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
              )),
            ),
            TextButton(onPressed: (){
              setState(() {
                counter++;
              });
              }, child: Text('Plus',style: TextStyle(color: Colors.red),)),
          ],
        ),
      ),
    );
  }
}
