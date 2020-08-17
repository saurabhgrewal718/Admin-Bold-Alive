import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../welcome.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = './homescreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
              child: Center(
                child: Text('this is best thing to do'),
              ),
            ),
            FlatButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                final prefs = await SharedPreferences.getInstance();
                prefs.clear();
                final currentId = prefs.getString('userId');
                if(currentId == null){
                  Navigator.of(context).pushReplacementNamed(Welcome.routeName);
                }
              },
              child: Text('Signout'),
            )
          ],
        ),
    );
  }
}