import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './signupForm.dart';
import '../../Animation/FadeAnimation.dart';
import '../login/loginScreen.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height+70,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(1, Text("Sign up", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),)),
                  SizedBox(height: 20,),
                  FadeAnimation(1.2, Text("Create an account, It's free", style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700]
                  ),)),
                ],
              ),
              SignupForm(),             
              FadeAnimation(1, Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  FlatButton(
                        child: Text("Log In", style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18
                      ),),
                        onPressed: (){
                          // Firestore.instance.collection('users/e0M946OayF2HIgrKomjN/profile')
                          // .document('DBQG6ku1u3LUgkCZKN93')
                          // .setData({
                          //    'text':"oooo Bhenchoddd ke"
                          //   });
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(LoginScreen.routeName,); 
                        }
                      ),
                ],
              )),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}