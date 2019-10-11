import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_app/datas/cart_product.dart';
import 'package:loja_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{
  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;

  CartModel({@required this.user}){
    if(user.isLoggedIn())
      _loadCartItems();
  }

  static CartModel of(BuildContext context){
    return ScopedModel.of<CartModel>(context);
  }

  void addCartItem(CartProduct cartProduct) async{
    try {
      var doc = await Firestore
      .instance
      .collection("users")
      .document(user.firebaseUser.uid).collection("cart").add(cartProduct.toMap());
      cartProduct.cid = doc.documentID;

      products.add(cartProduct);
      notifyListeners();
    } catch (e) {
      print(e);
    }

    
  }

  void removeCartItem(CartProduct cartProduct) async{
    try {
      await Firestore
      .instance
      .collection("users")
      .document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).delete();

      products.remove(cartProduct);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;
    Firestore
    .instance
    .collection("users")
    .document(user.firebaseUser.uid)
    .collection("cart")
    .document(cartProduct.cid)
    .updateData(cartProduct.toMap());

    notifyListeners();
  }
  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;
    Firestore
    .instance
    .collection("users")
    .document(user.firebaseUser.uid)
    .collection("cart")
    .document(cartProduct.cid)
    .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .getDocuments();

    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;
  }
   double getDiscount(){
     double valor = (getProductsPrice() * discountPercentage / 100);
     if(valor > 0){
       valor *= -1;
     }
    return valor;
  }

  double getShipPrice(){
    return 9.99;
  }

  Future<String> finishOrder() async {
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser.uid,
        "products": products.map((cartProduct)=>cartProduct.toMap()).toList(),
        "shipPrice": shipPrice,
        "productsPrice": productsPrice,
        "discount": discount,
        "totalPrice": productsPrice - discount + shipPrice,
        "status": 1
      }
    );

    await Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("orders").document(refOrder.documentID).setData(
      {
        "orderId": refOrder.documentID
      }
    );

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void updatePrices(){
    notifyListeners();
  }

}