import 'dart:math';

import 'package:app_examen/modules/bmi_result/bmi_result_screen.dart';
import 'package:flutter/material.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  bool isMale = true;
  double height = 120;
  int weight = 80;
  int age = 30;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('BMI Calculator',style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          isMale = true ;
                        });
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                                image: AssetImage('assets/images/male.png'),
                                height: 70,
                                width: 70,
                            ),
                            Text('MALE',
                            style:TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ))
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isMale ? Colors.blue : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState(( ) {
                        isMale = false;
                      });
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/female.png'),
                            height: 70,
                            width: 70,
                          ),
                          Text('FEMALE',
                              style:TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ))
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isMale ? Colors.grey[300] : Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('HEIGHT',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('${height.round()}',style:TextStyle(fontSize: 40,fontWeight: FontWeight.w900)),
                        Text('cm',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                        value: height,
                        max: 220,
                        min: 80,
                        onChanged:(value)
                        {
                          setState(() {
                            height = value;
                          });
                        })
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300]
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: [
                        Text('WEIGHT',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                        Text('$weight',style:TextStyle(fontSize: 40,fontWeight: FontWeight.w900)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(onPressed: (){
                              setState(() {
                                weight--;
                              });
                            },
                                heroTag: 'weight-',
                                mini:true,
                                child: Icon(Icons.remove)),
                            FloatingActionButton(onPressed: (){
                              setState(() {
                                weight++;
                              });
                            },
                                heroTag: 'weight+',
                                mini:true,child: Icon(Icons.add)),
                          ],
                        )
                      ],
                    ),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                  )
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center ,
                        children: [
                          Text('AGE',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                          Text('$age',style:TextStyle(fontSize: 40,fontWeight: FontWeight.w900)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(onPressed: (){
                                setState(() {
                                  age--;
                                });
                              },
                                  heroTag: 'age-',
                                  mini:true,child: Icon(Icons.remove)),
                              FloatingActionButton(onPressed: (){
                                setState(() {
                                  age++;
                                });
                              },
                                  heroTag: 'age+',
                                  mini:true,child: Icon(Icons.add)),
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      )
                  ),
                ),
              ],
              ),
            ),
          ),
          Container(
              width:double.infinity,
            color : Colors.black,
            child: MaterialButton(onPressed:(){
              double result = (weight / pow(height/100,2)) ;
              print(result.round());
              Navigator.push(context,MaterialPageRoute(builder: (context)=>BMIResultScreen(
                age: age,
                isMale : isMale,
                result : result,
              )
              )
              );
            },
                height: 50,
                child: Text('CALCULATE',
                style: TextStyle(color: Colors.white),)))
        ],
      ),
    );
  }
}
