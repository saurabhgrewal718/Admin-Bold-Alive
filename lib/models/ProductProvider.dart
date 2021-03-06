import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Product.dart';

class ProductModel with ChangeNotifier{
  List <Products> _profile = [];
  List<Products> get items{
    return [..._profile];
  }

Future<void> fetchAndSetProducts() async {
    try {
      
  final List<Products> loadedProducts = [];
  
  Firestore.instance
  .collection("products")
  .getDocuments()
  .then((querySnapshot) {
  querySnapshot.documents.forEach((result) {
        String _myprice;
        _myprice = result.data['price'].toString();
        loadedProducts.add(Products(
          title: result.data['title'],
          price: int.parse(_myprice),
          description: result.data['description'],
          image: result.data['image'],
          id:result.data['id'],
          catagory: result.data['catagory'],
          imgDetail: result.data['imgDetail'],
          hidden: result.data['hidden']
        )
      );
 
    print('datafetched');
    _profile = loadedProducts;
      
    notifyListeners();
  });
});
     
  } catch (error) {
    throw (error);
  }
}

Future<void> fetchCatagories(String catagory) async {
    try {
      
  final List<Products> loadedProducts = [];
  print(catagory);
  Firestore.instance
  .collection("products")
  .where("catagory", isEqualTo: "$catagory")
  .getDocuments()
  .then((querySnapshot) {
  querySnapshot.documents.forEach((result) {
        String _myprice;
        _myprice = result.data['price'].toString();
        loadedProducts.add(Products(
          title: result.data['title'],
          price: int.parse(_myprice),
          description: result.data['description'],
          image: result.data['image'],
          id:result.data['id'],
          catagory: result.data['catagory'],
          imgDetail: result.data['imgDetail'],
          hidden: result.data['hidden']
        )
      );
 
    print(result.data);
    _profile = loadedProducts;
      
    notifyListeners();
  });
});
     
  } catch (error) {
    throw (error);
  }
}

Future<void> fetchHidden() async {
try { 
  final List<Products> hiddenProducts = [];
  Firestore.instance
  .collection("products")
  .where("hidden", isEqualTo: true)
  .getDocuments()
  .then((querySnapshot) {
  querySnapshot.documents.forEach((result) {
    String _myprice;
    _myprice = result.data['price'].toString();
    hiddenProducts.add(Products(
      title: result.data['title'],
      price: int.parse(_myprice),
      description: result.data['description'],
      image: result.data['image'],
      id:result.data['id'],
      catagory: result.data['catagory'],
      imgDetail: result.data['imgDetail'],
      hidden: result.data['hidden']
    )
  );
 
    print(result.data);
    _profile = hiddenProducts;
      
    notifyListeners();
  });
});
     
  } catch (error) {
    throw (error);
  }
}

//deleting product totally will be implemented after adding a new product
// Future<void> deleteProduct(String myId)async{
//     try{
//       String urlString = '';
//       final prefs = await SharedPreferences.getInstance();
//       final userIdentity = prefs.getString('userId')?? int.parse('0');

//       if( userIdentity != null || userIdentity != 0){
//           urlString = userIdentity;
//           print('used from shared preferences');  
//       }else{
//         final userData = await FirebaseAuth.instance.currentUser();
//         urlString = userData.uid;
//       }

//       await Firestore.instance
//       .collection('users/$urlString/mypings')
//       .getDocuments()
//       .then((querysnapshot) {
//         querysnapshot.documents.forEach((element) async{
//           if(element.data['pid'] == myId){
//             await Firestore.instance
//               .collection('users/$urlString/mypings').document(element.data['documentId']).delete();
//           }
//         });
//       });
//       notifyListeners();

//     }catch(err){
//       print('deletion failed');
//       notifyListeners();
//     }
//   }



}