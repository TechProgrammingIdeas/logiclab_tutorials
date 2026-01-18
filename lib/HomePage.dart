import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logiclab_tutorials/Global/PublicFunctions.dart';
import 'package:logiclab_tutorials/Tutorials/PDFIndex.dart';
import 'package:logiclab_tutorials/Tutorials/Paginationbutton.dart';
import 'package:logiclab_tutorials/Tutorials/Paginationscroll.dart';
import 'package:logiclab_tutorials/Tutorials/ReportPage.dart';
import 'package:logiclab_tutorials/Tutorials/Spinkit.dart';
import 'package:logiclab_tutorials/Tutorials/VideoplayAndroidIos.dart';
import 'package:logiclab_tutorials/Tutorials/mobiletext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('LogicLab Academy'),
      ), 
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Spinkit()),);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Spinkit Examples'),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Mobiletext()),);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Mobile Input'),
                ),
              ),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.push(context,MaterialPageRoute(builder: (context) => ReportPage()),);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Share PDF'),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    print("123");
                    // try {                      
                    //   //final result = await InternetAddress.lookup('demo7.logiclabsolutions.com');
                    //   final result = await InternetAddress.lookup('192.168.1.35');
                    //   print('Lookup result: $result');
                    // } catch (e) {
                    //   print('Lookup failed: $e');
                    // }
                    try {
  final result = await InternetAddress.lookup('46.4.61.150');
  print('Google lookup: $result');
} catch (e) {
  print('Google failed: $e');
}
                    print("dsfds");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Check DNS'),
                ),
              ),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Paginationscroll()),);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Pagination Scroll'),
                ),
              ),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => PaginationButton()),);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Pagination Button'),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.push(context,MaterialPageRoute(builder: (context) => VideoPlayerScreen()),);

                    String deviceId = await getDeviceId();

                    print("Device ID " + deviceId);


                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Device Id'),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => PDFIndex()),);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('PDF VIew'),
                ),
              ),







              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Elevated Button'),
                ),
              ),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('Elevated Button'),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 12.0,
                  ),
                  child: const Text('LogicLab'),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}