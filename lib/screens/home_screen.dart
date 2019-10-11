import 'package:flutter/material.dart';
import 'package:loja_app/tabs/home_tab.dart';
import 'package:loja_app/tabs/orders_tab.dart';
import 'package:loja_app/tabs/places_tab.dart';
import 'package:loja_app/tabs/products_tab.dart';
import 'package:loja_app/widgets/CartButton.dart';
import 'package:loja_app/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(pageController: _pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          body: ProductsTab(),
          drawer: CustomDrawer(pageController: _pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(//
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
        Scaffold(//
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
      ],
    );
  }
}