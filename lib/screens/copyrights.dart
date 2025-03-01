import 'package:flutter/material.dart';

class CopyRights extends StatelessWidget {
  const CopyRights({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CopyRights'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(height: 20),
             Text(
              'Punjab University\nGujranwala Campus',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            Text('This app is created by'),
            Text('Waleed Qamar', style: TextStyle(fontWeight: FontWeight.bold),),
            Text("Roll Number: BCS23023"),
            SizedBox(height: 20),
            Text("All rights reserved."),
            Text('This app is created for educational purposes only.'),
          ],
        ),

      ),
    );
  }
}