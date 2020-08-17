import 'package:AdminBoldAlive/screens/home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _isLoading = false;
  final _pass = FocusNode();
  final _form = GlobalKey<FormState>();
  String _email='';
  String _password = '';
  final _auth = FirebaseAuth.instance;
  List<dynamic> myList;
  List<String> myNewList;
  

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  
  void _saveForm() async{
        
    final isValid = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      setState(() {
      _isLoading= true;
    });
      _form.currentState.save();
      AuthResult authResult;

      try{
        authResult = await _auth.signInWithEmailAndPassword(email: _email.trim(), password: _password.trim());
        print(authResult);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', authResult.user.uid);
        
        if(authResult!=null ){
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
           
        }

        // final document = Firestore.instance.collection('users/${authResult.user.uid}/personal').document('${authResult.user.uid}');
        // final documentlist = await document.get();
        
        // final prefs = await SharedPreferences.getInstance();
        // prefs.setString('userId', authResult.user.uid);
        
        // print('name is');
        // print(documentlist['name']);
        // print(prefs.getString('name'));
        // prefs.setString('name', documentlist['name']);
        // prefs.setString('age', documentlist['age']);
        // prefs.setString('userProfilePicture', documentlist['profile_picture']);
        // prefs.setString('gender', documentlist['gender']);
        // prefs.setString('course', documentlist['course']);
        // prefs.setString('bio', documentlist['bio']);
        // prefs.setString('can', documentlist['can']);
        // prefs.setString('things', documentlist['things']);
        // prefs.setString('who', documentlist['who']);
        // prefs.setString('instagram', documentlist['instagram']);
        // print('this is the AUTH');            
        // print(authResult);

        setState(() {
            _isLoading= false;
          });
        
        
      }on PlatformException catch(err){

        var message= "An error occured ! PLease check Your Credentials";
        if(err.message != null){
          message= err.message;
        }
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(message ,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
          ),
        ));

        setState(() {
          _isLoading= false;
        });

      }catch(err){
        print(err);

      }

    }

  }



  @override
  Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Form(
            key: _form,
            child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    
                    SizedBox(height: 30,),
                    
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Email', style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87
                          ),),
                          SizedBox(height: 5,),
                          TextFormField(
                            validator: (value){
                              if(value.isEmpty || !value.contains('@') || !value.contains('.com') || value.length <10){
                                return "Enter valid Email";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400])
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400])
                              ),
                            ),
                            onFieldSubmitted: (_){
                              FocusScope.of(context).requestFocus(_pass);
                            },
                            onSaved: (value){
                              _email=value;
                            },
                          ),
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Password', style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87
                          ),),
                          SizedBox(height: 5,),
                          TextFormField(
                            validator: (value){
                              if(value.isEmpty || value.length<6){
                                return "Enter atleast 6 Characters";
                              }
                              return null;
                            },
                            focusNode: _pass,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400])
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400])
                              ),
                            ),
                            onFieldSubmitted: (_){
                              FocusScope.of(context).unfocus();
                            },
                            onSaved: (value){
                              _password=value;
                            },
                          ),
                          SizedBox(height: 60,),
                        ],
                      ),
                    ),
                    _isLoading ? Center(child:CircularProgressIndicator(backgroundColor: Colors.greenAccent)) :
                    Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                            _saveForm();
                            
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Login", style: TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 18
                        ),),
                      ),
                    ),           
                   ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}





