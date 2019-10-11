import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_app/datas/cart_product.dart';
import 'package:loja_app/datas/product_data.dart';
import 'package:loja_app/models/cart_model.dart';
import 'package:loja_app/models/user_model.dart';
import 'package:loja_app/screens/cart_screen.dart';
import 'package:loja_app/screens/login_sreen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  const ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _sizeSelected;

  @override
  Widget build(BuildContext context) {
    final Color _pimaryColor = Theme.of(context).primaryColor;
    final ProductData product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Carousel(
              images: product.images.map((url) => NetworkImage(url)).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: _pimaryColor,
              autoplay: false,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _pimaryColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 4),
                    children: product.sizes.map((size) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _sizeSelected = size;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: _sizeSelected == size
                                  ? _pimaryColor
                                  : Colors.grey[500],
                              width: 3,
                            ),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(size),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: RaisedButton(
                    color: _pimaryColor,
                    textColor: Colors.white,
                    onPressed: _sizeSelected == null ? null : (){
                      if(UserModel.of(context).isLoggedIn()){
                        CartProduct cartProduct = CartProduct(
                          size: _sizeSelected,
                          category: product.category,
                          quantity: 1,
                          pid: product.id,
                        );
                        cartProduct.productData = product;
                        CartModel.of(context).addCartItem(cartProduct);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CartScreen()
                        ));
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScrenn()
                        ));
                      }
                    },
                    child: Text(
                      UserModel.of(context).isLoggedIn() ? "Adicionar ao Carrinho" : "Entre para Comprar",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
