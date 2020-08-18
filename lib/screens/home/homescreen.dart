import 'package:AdminBoldAlive/screens/home/products.dart';
import 'package:flutter/material.dart';
import './addproduct.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = './homescreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
            Icons.dashboard,
            color: Colors.black45,
          ),
        onPressed: (){},
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.black45,
          ),
          onPressed: showMenu,
        ),
        IconButton(
          icon: Icon(
            Icons.shopping_basket,
            color: Colors.black45,
          ),
          onPressed: () {
            // Navigator.of(context).pushNamed(CartScreen.routeName);
          },
        ),
        IconButton(
          icon: Icon(Icons.edit,
            color: Colors.black45,
          ),
          onPressed: (){
            Navigator.of(context).pushNamed(AddProduct.routeName);
          },
        ),
        SizedBox(width: 20)
      ],
    ),
      body: Products(),
    );
  }
}