import '../home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignupForm extends StatefulWidget {

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _auth = FirebaseAuth.instance;
  final _username = FocusNode();
  final _pass = FocusNode();
  final _confirmpass = FocusNode();
  final _form = GlobalKey<FormState>();
  final TextEditingController _passw = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  String _email='';
  String _password = '';
  String _usrname = '';
  var _isLoading= false;

  @override
  void dispose() {
    _username.dispose();
    _pass.dispose();
    _confirmpass.dispose();
    super.dispose();
  }

  void _saveForm() async{
    
    final isValid = _form.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){

      setState(() {
      _isLoading = true;
    });
      _form.currentState.save();
      AuthResult authResult;

      try{
        //signup
        authResult = await _auth.createUserWithEmailAndPassword(email: _email.trim(), password: _password.trim());
        print(authResult);
        
        
        //saving the data in the users     
        await Firestore.instance.collection('users').document(authResult.user.uid).setData({
          'username':_usrname,
          'email':_email,
          'password':_password,
          'id':authResult.user.uid
        });
        //saving the is in the internal storage
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', authResult.user.uid);

        //getting the id in this userIdentity variable here
        final userIdentity = prefs.getString('userId') ?? 0;

        //showing congratulatory Snackbar on sucesful signup
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 1),
            content: Text('Contratulations',
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
            ),
          ));
        //redirecting to a new page
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName,
          arguments: authResult.user.uid
        );
        setState(() {
          _isLoading = false;
        });


      }on PlatformException catch(err){
        //shwoing errpor messages
        var message= "An error occured ! PLease check Your Credentials";
        if(err.message != null){
          message= err.message;
        }
        setState(() {
          _isLoading = false;
        });
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

      }catch(err){
        setState(() {
          _isLoading = false;
        });
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
            padding: EdgeInsets.symmetric(horizontal: 0),
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
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                              if(value.isEmpty || !value.contains('@') || !value.contains('.com') || value.length <10){
                                return "Enter valid Email";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
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
                              FocusScope.of(context).requestFocus(_username);
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
                          Text('Username', style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87
                          ),),
                          SizedBox(height: 5,),
                          TextFormField(
                            validator: (value){
                              if(value.isEmpty || value.length <4){
                                return "Username Must have Alteast 4 Characters";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400])
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400])
                              ),
                            ),
                            focusNode: _username,
                            onFieldSubmitted: (_){
                              FocusScope.of(context).requestFocus(_pass);
                            },
                            onSaved: (value){
                              _usrname=value;
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
                            controller: _passw,
                            validator: (value){
                              if(value.isEmpty || value.length<6){
                                return "Enter atleast 6 Characters";
                              }
                              return null;
                            },
                            focusNode: _pass,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
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
                              FocusScope.of(context).requestFocus(_confirmpass);
                            },
                            onSaved: (value){
                              _password=value;
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
                          Text('Confirm Password', style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87
                          ),),
                          SizedBox(height: 5,),
                          TextFormField(
                            controller:_confirmPass,
                            validator: (value){
                              if(value.isEmpty || value.length<6 || value!=_passw.text){
                                return "Passwords Don't match!";
                              }
                              return null;
                            },
                            focusNode: _confirmpass,
                            obscureText: true,
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
                            
                          ),
                          SizedBox(height: 60,),
                        ],
                      ),
                    ),
                    _isLoading ? Center(child:CircularProgressIndicator(backgroundColor: Colors.greenAccent)) : Container(
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
                        child: Text("SignUp", style: TextStyle(
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





