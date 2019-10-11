import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_app/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              initialValue: CartModel.of(context).couponCode ?? "",
              decoration: InputDecoration(
                hintText: "Digite seu cupom",
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (text) async{
                DocumentSnapshot documentSnapshot = await Firestore.instance.collection("coupons").document(text).get();
                if(documentSnapshot.data != null){
                  CartModel.of(context).setCoupon(text, documentSnapshot.data["percent"]);
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Desconto de ${documentSnapshot.data["percent"]}% aplicado!"),
                      backgroundColor: Theme.of(context).primaryColor,)
                    );
                }else{
                  CartModel.of(context).setCoupon(null, 0);
                  Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Cupom não existente!"),
                          backgroundColor: Colors.redAccent,)
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
