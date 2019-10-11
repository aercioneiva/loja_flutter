import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_app/datas/cart_product.dart';
import 'package:loja_app/datas/product_data.dart';
import 'package:loja_app/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      
      return Row(
        
        children: <Widget>[
          Container(
            width: 120,
            padding: EdgeInsets.all(8),
            child: Image.network(
              cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.productData.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    cartProduct.size,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "R\$ ${cartProduct.productData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.remove),
                        onPressed: cartProduct.quantity == 1 ? null : (){
                          CartModel.of(context).decProduct(cartProduct);
                        },
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.add),
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: () {
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection("products")
                  .document(cartProduct.category)
                  .collection("items")
                  .document(cartProduct.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cartProduct.productData =
                      ProductData.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
