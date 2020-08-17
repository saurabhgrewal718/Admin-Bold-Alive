import 'package:AdminBoldAlive/models/Product.dart';
import 'package:flutter/material.dart';


class ItemCard extends StatelessWidget {
  final Products product;
  final Function press;
  const ItemCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.title}",
                child: 
                  Image.network(product.image,fit: BoxFit.cover,
                    loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Colors.greenAccent,
                        value: loadingProgress.expectedTotalBytes != null ? 
                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20 / 4),
            child: Text(
              // products is out demo list
              product.title,
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Text(
            "\₹ ${product.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
