import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/cart_screen.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/widgets/cart_button.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  int _currentCount = 0;
  late ColorData colorSelected;

  _ProductScreenState(this.product) {
    colorSelected = product.colors[0];
  }

  Color _getColorProductFromHex(ColorData color) {
    // if(color.colorHex.isEmpty) return Colors.transparent;
    String colorHex = color.colorHex;
    colorHex = colorHex.replaceFirst('#', '');
    if (colorHex.length == 6) {
      colorHex = 'FF$colorHex';
    }

    return Color(int.parse(colorHex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          product.title,
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      floatingActionButton: const CartButton(),
      body: ListView(
        children: [
          Stack(alignment: Alignment.bottomCenter, children: [
            AspectRatio(
              aspectRatio: 1,
              child: CustomCarousel(
                itemCountAfter: 0,
                itemCountBefore: _currentCount,
                physics: PageScrollPhysics(),
                onSelectedItemChanged: (item) {
                  setState(() {
                    _currentCount = item;
                  });
                },
                controller:
                    CustomCarouselScrollController(initialItem: _currentCount),
                scrollDirection: Axis.horizontal,
                effectsBuilder: CustomCarousel.effectsBuilderFromAnimate(
                    effects: EffectList().shakeX()),
                children: colorSelected.images.map((image) {
                  return Card(
                    margin: EdgeInsets.all(20),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              bottom: 25,
              child: DotsIndicator(
                dotsCount: colorSelected.images.length,
                position: _currentCount,
              ),
            ),
          ]),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2).replaceFirst(".", ",")}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                !product.colors.first.colorHex.isEmpty
                    ? SizedBox(
                        height: 16,
                      )
                    : Container(),
                !product.colors.first.colorHex.isEmpty
                    ? Text(
                        "Cor",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 44,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    children: product.colors.map((color) {
                      return !color.colorHex.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentCount = 0;
                                  colorSelected = color;
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getColorProductFromHex(color),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1.2),
                                  boxShadow: color == colorSelected
                                      ? [
                                          BoxShadow(
                                            color:
                                                Theme.of(context).primaryColor,
                                            offset: Offset(2, 2),
                                            blurRadius: 20,
                                            spreadRadius: 3,
                                          )
                                        ]
                                      : null,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                ),
                              ),
                            )
                          : Container();
                    }).toList(),
                  ),
                ),
                !product.colors.first.colorHex.isEmpty
                    ? SizedBox(
                        height: 16,
                      )
                    : Container(),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: colorSelected != ''
                        ? () {
                            if (UserModel.of(context).isLoggedIn()) {
                              if (CartModel.of(context)
                                  .products
                                  .where((productCart) =>
                                      productCart.productId == product.id && productCart.color == colorSelected.colorTitle)
                                  .isNotEmpty) {
                                CartProduct cartProduct = CartModel.of(context).products.where((cart) => cart.productId == product.id && cart.color == colorSelected.colorTitle).first;
                                CartModel.of(context).incProduct(cartProduct);
                              } else {
                                CartProduct cartProduct = CartProduct();
                                cartProduct.color = colorSelected.colorTitle;
                                cartProduct.quantity = 1;
                                cartProduct.productId = product.id;
                                cartProduct.category = product.category;
                                cartProduct.productData = product;

                                CartModel.of(context).addCartItem(cartProduct);
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao Carrinho"
                          : "Entre para comprar",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
