import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/screens/cart_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:badges/badges.dart' as badges;

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartModel>(
      builder: (context, child, model) {
        return badges.Badge(
          badgeAnimation: badges.BadgeAnimation.scale(),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.blue,
            padding: EdgeInsets.all(6),
          ),
          badgeContent: Text(
            model.products.length.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16
            ),
          ),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
