import 'package:eticket_atc/screens/FormPage.dart';
import 'package:eticket_atc/widgets/graidentIcon.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GradientIcon(
                size: 60,
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
            SizedBox(
              height: 35,
              width: 100,
              child: ElevatedButton(
                
                onPressed: (){
                  //redirect to login
                }, 
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                  backgroundColor: Colors.lightBlue[500]
                ),
                child: Text('Login',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,
                color: Colors.grey[50]
                ),
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(
              width: double.infinity,
              child: Image.asset('assets/images/bus_banner.jpg'),
            ),
            Forms(),

          ]),
      ),
    );
  }
}