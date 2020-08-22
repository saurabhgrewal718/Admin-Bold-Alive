import 'package:AdminBoldAlive/models/Product.dart';
import 'package:AdminBoldAlive/screens/home/homescreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ProductTitleWithImage extends StatefulWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Products product;

  @override
  _ProductTitleWithImageState createState() => _ProductTitleWithImageState();
}

class _ProductTitleWithImageState extends State<ProductTitleWithImage> {
  bool isloading = false;

  Widget choiceButton(String value){
    return Container(
        padding: EdgeInsets.only(top: 3, left: 3),
        width: MediaQuery.of(context).size.width*0.23,
        margin: EdgeInsets.only(left:20,right:20,bottom:20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border(
            bottom: BorderSide(color: Colors.green),
            top: BorderSide(color: Colors.green),
            left: BorderSide(color: Colors.green),
            right: BorderSide(color: Colors.green),
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(value,textAlign: TextAlign.center, style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 18,
              color: Colors.black
            ),),
        ),
      );
  }

  void hideproduct(BuildContext context)async{
    HapticFeedback.vibrate();
    setState(() {
      isloading = true;
    });
    try{
      await Firestore.instance
        .collection('products')
        .getDocuments()
        .then((querysnapshot) {
        querysnapshot.documents.forEach((element) async{
          if(element.data['id'] == widget.product.id){
            await Firestore.instance
              .collection('products').document(widget.product.id).updateData({
                'hidden':true
              });
          }
        });
      });
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(
        msg: "Product sucessfully Hidden",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0
      );
      Navigator.of(context).pop();
    }catch(err){
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(
        msg: "$err",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

void deleteproduct(BuildContext context)async{
  HapticFeedback.vibrate();
  try{
    setState(() {
      isloading = false;
    });
    await Firestore.instance
      .collection('products')
      .getDocuments()
      .then((querysnapshot) {
      querysnapshot.documents.forEach((element) async{
        if(element.data['id'] == widget.product.id){
          await Firestore.instance
            .collection('products').document(widget.product.id).delete();
        }
      });
    });
    Fluttertoast.showToast(
      msg: "Product sucessfully Deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0
    );
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

  }catch(err){
    setState(() {
      isloading = false;
    });
    Fluttertoast.showToast(
      msg: "$err",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.orangeAccent,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}

  void _showAlert(BuildContext context,String value,String action){
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title:Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('$action this Product?',textAlign: TextAlign.center, style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: 18,
            color: Colors.black
          ),),
        ),
        content: Container(height: 1,color: Colors.black12,),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              value == 'hide' ? 
              FlatButton(
                onPressed: (){
                  hideproduct(context);
                }, 
                child: choiceButton('Yes')
              ):FlatButton(
                onPressed: (){
                  deleteproduct(context);
                }, 
                child:choiceButton('Yes')
              ),
              FlatButton(
                onPressed: (){
                  Navigator.of(ctx).pop();
                }, 
                child: choiceButton('No')
              )
            ],
          )
        ],
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    int containerheight = 200;
    List<dynamic> images = widget.product.imgDetail;
    widget.product.description.length > 300 ? containerheight = 500 : containerheight = 300;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: MediaQuery.of(context).size.height+containerheight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Catagory : ${widget.product.catagory}",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${widget.product.title}",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(10),
              child: Text(
                "Description : ${widget.product.description}",
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
            ),
            SizedBox(height:30),
            Text(
              "Product Id : ${widget.product.id}",
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
                        text: "\₹ ${widget.product.price}",
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
                    tag: "Product Id : ${widget.product.id}",
                    child: Image.network(
                      widget.product.image,
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
            Center(
              child: Column(
                children: <Widget>[
                  widget.product.hidden == false ?
                  isloading == true ? Container(child:CircularProgressIndicator(backgroundColor: Colors.greenAccent,)):Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    padding: EdgeInsets.only(top: 3, left: 3),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: (){
                        _showAlert(context,'hide','Hide');
                      },
                      color: Colors.blue[200],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text('Hide Product', style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 18,
                        color: Colors.black
                      ),),
                    ),
                  ) : Container(child:Center(child:Text('Product Already hidden'))),
                  isloading == true ? Container(child:CircularProgressIndicator(backgroundColor: Colors.greenAccent,)) : Container(
                    width: MediaQuery.of(context).size.width*0.4,
                    padding: EdgeInsets.only(top: 3, left: 3),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: (){
                        _showAlert(context,'delete','Delete');
                      },
                      color: Colors.red[200],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text('Delete Product', style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 18,
                        color: Colors.black
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
