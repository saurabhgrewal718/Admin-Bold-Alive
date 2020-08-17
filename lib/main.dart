import 'package:AdminBoldAlive/models/ProductProvider.dart';
import 'package:AdminBoldAlive/screens/home/products.dart';
import 'package:AdminBoldAlive/screens/login/notauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './welcome.dart';
import './screens/login/loginScreen.dart';
import './screens/login/notauth.dart';

import 'screens/home/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ProductModel(),),
          ],
          child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginApp(),
          routes: {
            HomeScreen.routeName : (ctx) => HomeScreen(),
            Welcome.routeName : (ctx) => Welcome(),
            LoginScreen.routeName : (ctx) => LoginScreen(),
            Products.routeName : (ctx) => Products()
            // CartScreen.routeName : (ctx) => CartScreen(),
            // OrderPage.routeName : (ctx) => OrderPage(),
            // EditScreen.routeName :(ctx) => EditScreen(),
            // EditSceond.routeName : (ctx) => EditSceond(),
            // UploadImage.routeName :(ctx) => UploadImage(),
            // CompleteOrder.routeName :(ctx) => CompleteOrder(),
            // FillDetails.routeName :(ctx) => FillDetails(),
            // Chips.routeName : (ctx) => Chips(),
            // Placeorder.routeName : (ctx) => Placeorder(),

            // //the various screen for conditional rendering
            // Hoodie.routeName : (ctx) => Hoodie(),
            // Kitchen.routeName : (ctx) => Kitchen(),
            // Mugs.routeName : (ctx) => Mugs(),
            // Phone.routeName : (ctx) => Phone(),
            // Photo.routeName : (ctx) => Photo(),
            // Shirts.routeName : (ctx) => Shirts(),
                      
          },
          onUnknownRoute: (settings){
            return MaterialPageRoute(builder: (ctx) => NotAuth(),);
          }
        ),
    );
  }
}

class LoginApp extends StatefulWidget {
  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
          child:
          StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (ctx,usersnapshot){
              CircularProgressIndicator();
              if(usersnapshot.hasData){
                return HomeScreen();
              }
              return Welcome();
            },
          ),
           
    );
  }
}
