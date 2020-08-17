import 'package:AdminBoldAlive/models/Product.dart';
import 'package:flutter/material.dart';


class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Products product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${product.catagory}",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              product.title,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              product.description,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Price\n"),
                      TextSpan(
                        text: "\₹ ${product.price}",
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.only(right:50),
                  height: 150,
                  width: 150,
                  child: Hero(
                    tag: "${product.id}",
                    child: Image.network(
                      product.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
