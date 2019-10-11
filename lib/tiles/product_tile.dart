import 'package:flutter/material.dart';
import 'package:loja_app/datas/product_data.dart';
import 'package:loja_app/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  const ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
        child: type == 'grid' ? _column(context) : _row(context),
      ),
    );
  }

  Widget _conteudo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          product.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "R\$ ${product.price.toStringAsFixed(2)}",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _row(context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Image.network(
            product.images[0],
            fit: BoxFit.cover,
            height: 220,
          ),
        ),
        Flexible(
          flex: 1,
          child: _conteudo(context),
        ),
      ],
    );
  }

  Widget _column(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.8,
          child: Image.network(
            product.images[0],
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: _conteudo(context),
          ),
        ),
      ],
    );
  }
}
