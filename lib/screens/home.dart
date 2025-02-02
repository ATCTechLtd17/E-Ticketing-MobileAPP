import 'package:eticket_atc/widgets/FormPage.dart';
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
            Text('Infinity'),
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