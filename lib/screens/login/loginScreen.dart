import 'package:AdminBoldAlive/screens/signup/signupscreen.dart';
import 'package:flutter/material.dart';
import './loginform.dart';
import '../../Animation/FadeAnimation.dart';
// import './signupscreen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                FadeAnimation(1, Text("Login", style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),)),
                SizedBox(height: 20,),
                FadeAnimation(0.5, Text("Login to your account", style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700]
                ),)),
              ],
            ),
            SizedBox(height: 30,),
            SingleChildScrollView(
              child: FadeAnimation(1,LoginForm()),
            ),
            SizedBox(height: 30,),
            FadeAnimation(1, Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account?"),
                  FlatButton(
                        child: Text("Sign Up", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18
                      ),),
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed(SignupScreen.routeName,); 
                        }
                      ),
                ],
              )),
          ],
        ),
      ),
    );
  }
}