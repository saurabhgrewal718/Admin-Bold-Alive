import 'package:AdminBoldAlive/models/Product.dart';
import 'package:flutter/material.dart';

import 'product_title_with_image.dart';

class Body extends StatelessWidget {
  final Products product;

  const Body({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(child: ProductTitleWithImage(product: product))
    );
  }
}
