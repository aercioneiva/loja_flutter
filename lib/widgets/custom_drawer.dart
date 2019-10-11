import 'package:flutter/material.dart';
import 'package:loja_app/models/user_model.dart';
import 'package:loja_app/screens/login_sreen.dart';
import 'package:loja_app/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer({this.pageController});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          _fundo(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.00, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        "Flutter\nLoja",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, cuild, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if(!model.isLoggedIn()){
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScrenn()));
                                  }else{
                                    model.signOut();
                                    Navigator.of(context).pop();
                                  }
                                  
                                },
                                child: Text(
                                  !model.isLoggedIn() ? "Entre ou cadastre-se >": "Sair",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(
                  icon: Icons.home,
                  text: "Início",
                  pageController: pageController,
                  page: 0),
              DrawerTile(
                  icon: Icons.list,
                  text: "Produtos",
                  pageController: pageController,
                  page: 1),
              DrawerTile(
                  icon: Icons.location_on,
                  text: "Lojas",
                  pageController: pageController,
                  page: 2),
              DrawerTile(
                  icon: Icons.playlist_add_check,
                  text: "Meus Pedidos",
                  pageController: pageController,
                  page: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fundo() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 203, 236, 241),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
