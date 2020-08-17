import 'package:AdminBoldAlive/screens/home/body.dart';
import 'package:AdminBoldAlive/screens/home/product_title_with_image.dart';
import 'package:flutter/material.dart';
import '../../models/Product.dart';

class DetailsScreen extends StatefulWidget {
  final Products product;
  
  const DetailsScreen({Key key, this.product}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int count = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // each product have a color
      backgroundColor: Colors.grey[200],
      appBar: buildAppBar(context,count),
      body: Body(product: widget.product),
    );
  }

  AppBar buildAppBar(BuildContext context,int count) {
    return AppBar(
      backgroundColor: Colors.grey[200],
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black45,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        // IconButton(
        //   icon: SvgPicture.asset("assets/icons/search.svg"),
        //   onPressed: () {},
        // ),
        
        SizedBox(width: 20 / 2)
      ],
    );
  }
}
