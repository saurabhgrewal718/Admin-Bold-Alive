import 'dart:io';
import 'package:AdminBoldAlive/screens/home/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multi_image_picker/multi_image_picker.dart';



class AddProduct extends StatefulWidget {
  static const routeName = './addproduct';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;

 var _isLoading = false;
  final _pass = FocusNode();
 
  final _form = GlobalKey<FormState>();

  String _catagory = '';
  String _title='';
  String _description = '';
  String _price;
  bool isLoading = false;
  double fileSize;
  final String documnetID = DateTime.now().millisecondsSinceEpoch.toString();

  
  File _mainImage;
  final picker = ImagePicker();

 Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Description Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,maxHeight: 800,maxWidth: 800);

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
      Scaffold.of(ctx).hideCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
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
    print(_price);

    void uploadImages(){
    for ( var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if(imageUrls.length==images.length){ 
          Firestore.instance.collection('products').document(documnetID).updateData({
            'imgDetail':imageUrls
          }).then((_){
            Fluttertoast.showToast(
              msg: "Description Images Upload Sucessful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.greenAccent,
              textColor: Colors.black,
              fontSize: 16.0
            );
            
            setState(() {
              images = [];
              imageUrls = [];
              _isLoading= false;

            });
            Navigator.of(ctx).pushReplacementNamed(HomeScreen.routeName);
            
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }
 
try{        
  final ref = FirebaseStorage.instance.ref().child('product_images/$_title').child('$_title.jpg');
  await ref.putFile(_mainImage).onComplete;
  final url = await ref.getDownloadURL();

  final prefs = await SharedPreferences.getInstance();
  prefs.getString('userId');

  if(images.length==0){
    print('no image selected');
  }else{
      uploadImages();
      Fluttertoast.showToast(
        msg: "Uploading Description images",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  await Firestore.instance.collection('products').document(documnetID).setData({
    'title': _title,
    'price': _price,
    'image': url,
    'id': documnetID,
    'hidden':false,
    'catagory': _catagory,
    'description': _description
  });

  Fluttertoast.showToast(
        msg: "Title and text uploaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.black,
        fontSize: 16.0
    );

  

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
                                    "display": "Shirts",
                                    "value": "Shirts",
                                  },
                                  {
                                    "display": "Hoodie",
                                    "value": "Hoodie",
                                  },
                                  {
                                    "display": "Phone Cases",
                                    "value": "Phone Cases",
                                  },
                                  {
                                    "display": "Kitchen Items",
                                    "value": "Kitchen Items",
                                  },
                                  // {
                                  //   "display": "Pillow",
                                  //   "value": "Pillow",
                                  // },
                                  
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
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
                                ? Text('No Title Image found')
                                : Image.file(_mainImage),
                            ),
                          ),
                          FlatButton(onPressed: getImage, child: Icon(Icons.add_a_photo)),
                        ],
                      ),
                      Center(child: Text('Error: $_error')),
                      RaisedButton(
                        child: Text("Pick images"),
                        onPressed: loadAssets,
                      ),
                      Container(
                        height:300,
                        child: buildGridView(),
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


