import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  Widget _buildDrawerBack() => Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(245, 47, 46, 46),
            Color.fromARGB(255, 10, 10, 10),
            Color.fromARGB(255, 22, 16, 16),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.grey,
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Container(
                        child: Text(
                          "Shopping\nGamer",
                          style: TextStyle(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..maskFilter =
                                  const MaskFilter.blur(BlurStyle.solid, 12)
                              ..color = Color.fromARGB(255, 173, 219, 237),
                            fontSize: 34,
                            letterSpacing: 5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Olá, ${!model.isLoggedIn() ? "" : model.userData['name']}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 197, 221, 231),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                !model.isLoggedIn() ?
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen())) : model.signOut();
                              },
                              child: Text(
                                !model.isLoggedIn() ?
                                "Entre ou cadastre-se >" : "Sair",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        );
                      }),
                    )
                  ],
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 197, 221, 231),
                endIndent: 35,
              ),
              DrawerTile("Início", Icons.home, pageController, 0),
              DrawerTile("Produtos", Icons.list, pageController, 1),
              DrawerTile("Lojas", Icons.location_on, pageController, 2),
              DrawerTile(
                  "Meus Pedidos", Icons.playlist_add_check, pageController, 3)
            ],
          )
        ],
      ),
    );
  }
}
