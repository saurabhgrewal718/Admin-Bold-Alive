import 'package:AdminBoldAlive/models/Product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Products product;

  @override
  Widget build(BuildContext context) {
    List<dynamic> images = product.imgDetail;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: MediaQuery.of(context).size.height+500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Catagory : ${product.catagory}",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${product.title}",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30,),
            Text(
              "Description : ${product.description}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black
              ),
            ),
            Text(
              "Product Id : ${product.id}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Price\n",style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "\₹ ${product.price}",
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                               
                Container(
                  margin: EdgeInsets.only(right:50),
                  height: 150,
                  width: 150,
                  child: Hero(
                    tag: "Product Id : ${product.id}",
                    child: Image.network(
                      product.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height:30),
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width ,
              child: images != null 
              ?
                Center(
                  child: CarouselSlider(
                    options: CarouselOptions(
                          height: 300,
                          aspectRatio: 16/9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                      ),
                    items: images.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white60
                            ),
                            child: Image.network(i)
                          );
                        },
                      );
                    }).toList(),
                  ),
                )

              : 
                Text('No Description images found '),
            ),
          ],
        ),
      ),
    );
  }
}
