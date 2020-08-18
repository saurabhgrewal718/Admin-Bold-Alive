import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class AddProduct extends StatefulWidget {
  static const routeName = './addproduct';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

 var _isLoading = false;
  final _pass = FocusNode();
 
  final _form = GlobalKey<FormState>();

  String _catagory = '';
  String _hide = '';
  String _title='';
  String _description = '';
  String _price;
  bool isLoading = false;
  double fileSize;

  File _mainImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _mainImage = File(pickedFile.path);
    });
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }
 
  void _saveForm(BuildContext ctx) async{  
    final isValid = _form.currentState.validate();
    FocusScope.of(ctx).unfocus();

     if(_mainImage == null){
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
          content: Text('Please select Product image',textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
          ),
        ));
    }
    
    if(isValid){
      _form.currentState.save();
      setState(() {
      _isLoading= true;
    });
    print(_title);
    print(_description);
    print(_catagory);
    print(_hide);
    print(_price);
    

    try{        
      
      final ref = FirebaseStorage.instance.ref().child('product_images/$_title').child('$_title.jpg');
      await ref.putFile(_mainImage).onComplete;
      final url = await ref.getDownloadURL();

       await Firestore.instance.collection('products').add({
              'title': _title,
              'price': _price,
              'image': url,
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'hidden':_hide,
              'catagory': _catagory,
              'description': _description
            });

      setState(() {
        _isLoading= false;
      }); 

    }on PlatformException catch(err){
      var message= "An error occured ! PLease check Your Credentials";
      if(err.message != null){
        message= err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
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
      return Scaffold(
          appBar: AppBar(
            title: Text('Add A Product To Live store')
          ),
          body: SingleChildScrollView(
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
                            Text('Product Title', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87
                            ),),
                            SizedBox(height: 5,),
                            TextFormField(
                              validator: (value){
                                if(value.isEmpty || value.length <4){
                                  return "Enter valid title";
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400])
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400])
                                ),
                              ),
                              
                              onSaved: (value){
                                _title=value;
                              },
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 30,),
                          ],
                        ),
                      ),
                      SizedBox(height:30),
                      Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5,),
                          DropDownFormField(
                                titleText: 'Hide Product',
                                hintText: 'Please choose one',
                                autovalidate: true,
                                value: _hide,
                                onSaved: (value) {
                                  setState(() {
                                    _hide = value;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _hide = value;
                                  });
                                },
                                dataSource: [
                                  {
                                    "display": "true",
                                    "value": "true",
                                  },
                                  {
                                    "display": "false",
                                    "value": "false",
                                  },
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
                      SizedBox(height:30),
                      Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5,),
                          DropDownFormField(
                                titleText: 'Product Catagory',
                                hintText: 'Please choose one',
                                value: _catagory,
                                autovalidate: true,
                                onSaved: (value) {
                                  setState(() {
                                    _catagory = value;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _catagory = value;
                                  });
                                },
                                dataSource: [
                                  {
                                    "display": "Mugs",
                                    "value": "Mugs",
                                  },
                                  {
                                    "display": "Climbing",
                                    "value": "Climbing",
                                  },
                                  {
                                    "display": "Walking",
                                    "value": "Walking",
                                  },
                                  {
                                    "display": "Swimming",
                                    "value": "Swimming",
                                  },
                                  {
                                    "display": "Soccer Practice",
                                    "value": "Soccer Practice",
                                  },
                                  {
                                    "display": "Baseball Practice",
                                    "value": "Baseball Practice",
                                  },
                                  {
                                    "display": "Football Practice",
                                    "value": "Football Practice",
                                  },
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
                    SizedBox(height:30),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Description', style: TextStyle(
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
                              style: TextStyle(color: Colors.black),
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
                              onSaved: (value){
                                _description=value;
                              },
                            ),
                            SizedBox(height: 60,),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Price', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87
                            ),),
                            SizedBox(height: 5,),
                            TextFormField(
                              validator: (value){
                                if(value.isEmpty){
                                  return "Cant leave price empty";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black),
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
                              onSaved: (value){
                                _price=value;
                              },
                            ),
                            SizedBox(height: 60,),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: 200,
                            child: Center(
                            child: _mainImage == null
                                ? Text('No image selected.')
                                : Image.file(_mainImage),
                            ),
                          ),
                          FlatButton(onPressed: getImage, child: Icon(Icons.add_a_photo)),
                        ],
                      ),

                      SizedBox(height:60),

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
                            _saveForm(context);  
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
                  SizedBox(height:60),
                ],
              ),
              
            ),
          ),
        ),
      );
  }
}


