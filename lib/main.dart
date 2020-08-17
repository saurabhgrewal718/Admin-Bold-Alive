import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/home/homescreen.dart';

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Bold ALive Admin',
//       theme: ThemeData(
       
//         primarySwatch: Colors.blue,
       
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() async{
//     await Firestore.instance
//     .collection("products")
//     .getDocuments()
//     .then((querySnapshot) {
//     querySnapshot.documents.forEach((result) {
//       print(result.data);      
//     });
//   });
//   }

//   @override
//   Widget build(BuildContext context) {
   
//     return Scaffold(
//       appBar: AppBar(
      
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
       
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginApp(),
        routes: {
          HomeScreen.routeName : (ctx) => HomeScreen(),
          // Welcome.routeName : (ctx) => Welcome(),
          // LoginScreen.routeName : (ctx) => LoginScreen(),
          // SignupScreen.routeName : (ctx) => SignupScreen(),
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
                return Text('auth ');
              }
              return Text('Not auth');
            },
          ),
           
    );
  }
}
