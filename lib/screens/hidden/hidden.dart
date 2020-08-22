import 'package:AdminBoldAlive/models/ProductProvider.dart';
import 'package:AdminBoldAlive/screens/home/detailscreen.dart';
import 'package:AdminBoldAlive/screens/home/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Hidden extends StatefulWidget {
  static const routeName = './hidden';
  @override
  _HiddenState createState() => _HiddenState();
}

class _HiddenState extends State<Hidden> {

   bool _inIt = true;

  @override
  void didChangeDependencies() async {
    if (_inIt) {
      Provider.of<ProductModel>(context,listen: false).fetchHidden();
    }
    _inIt = false;
    super.didChangeDependencies();
  }


   Future<void> onrefresh()async{
    HapticFeedback.vibrate();
      Provider.of<ProductModel>(context,listen: false).fetchHidden();
    
  }
  
  @override
  Widget build(BuildContext context) {
    final profiles = Provider.of<ProductModel>(context);
    final profile = profiles.items;
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            icon: Icon(
              Icons.hdr_strong,
              color: Colors.black45,
            ),
            onPressed: (){} ,
          ),
          IconButton(
            icon: Icon(
              Icons.cached,
              color: Colors.black45,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body:
        RefreshIndicator(
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
        ),
    );
  }
}

