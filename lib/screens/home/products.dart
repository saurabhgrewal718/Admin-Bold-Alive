import 'package:AdminBoldAlive/models/ProductProvider.dart';
import 'package:AdminBoldAlive/screens/home/detailscreen.dart';
import 'package:AdminBoldAlive/screens/home/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  static const routeName ='./products';
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

 bool _inIt = true;

  @override
  void didChangeDependencies() async {
    if (_inIt) {
      Provider.of<ProductModel>(context,listen: false).fetchAndSetProducts();
    }
    _inIt = false;
    super.didChangeDependencies();
  }


   Future<void> onrefresh()async{
    HapticFeedback.vibrate();
      Provider.of<ProductModel>(context,listen: false).fetchAndSetProducts();
    
  }

  @override
  Widget build(BuildContext context) {
    final profiles = Provider.of<ProductModel>(context);
    final profile = profiles.items;
    return RefreshIndicator(
          onRefresh: onrefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
                itemCount: profile.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => ItemCard(
                  product: profile[index],
                  press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          product: profile[index],
                        ),
                      )),
                )),
             
            ),
    );
  }
}