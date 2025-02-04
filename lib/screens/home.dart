import 'package:eticket_atc/screens/FormPage.dart';
import 'package:eticket_atc/widgets/graidentIcon.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GradientIcon(
                size: 70,
                icon: Icons.all_inclusive,
                gradientColors: [Colors.white, Colors.black],
                shimmerColors: [
                  Colors.lightBlue[300]!,
                  Colors.lightBlue[500]!,
                  Colors.purple[200]!,
                  Colors.purpleAccent[400]!,
                  Colors.deepPurpleAccent,
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (){
                //redirect to login
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[500]
              ),
              child: Text('Login',
              style: TextStyle(fontSize: 20,
              color: Colors.grey[50]
              ),
              ),
              
              )
          ],
        ),
        leading: IconButton(
          onPressed:(){
            //open drawer
          }, 
          icon: Icon(Icons.menu_outlined,
          size: 25,
          color: Colors.lightBlue[700],
          )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //banner image
          SizedBox(
            width: double.infinity,
            child: Image.asset('assets/images/bus_banner.jpg'),
          ),
          Forms(),
       
        ]),
    );
  }
}