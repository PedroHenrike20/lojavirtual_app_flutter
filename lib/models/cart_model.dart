import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;
  bool isLoading = false;
  List<CartProduct> products = [];
  String? couponCode;
  int discountPercentage = 0;

  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCartItem();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.cartId = doc.id;
    });

    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;

  }

  void updatePrices(){
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart").doc(cartProduct.cartId).delete();
    products.remove(cartProduct);
    notifyListeners();

  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;

    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart").doc(cartProduct.cartId).update(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart").doc(cartProduct.cartId).update(cartProduct.toMap());
    notifyListeners();
  }

  double getProductPrice(){
    double price = 0.0;
    for(CartProduct product in products){
      if(product.productData != null){
        price += product.quantity * product.productData!.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductPrice() * discountPercentage / 100;

  }

  double getShipPrice(){
    return 50.0;
  }

  Future<String?> finishOrder() async {
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await FirebaseFirestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser?.uid,
        "products": products.map((cart) => cart.toMap()).toList(),
        "shipPrice": shipPrice,
        "productsPrice": productsPrice,
        "discount": discount,
        "totalPrice": productsPrice + shipPrice - discount,
        "status": 1,
      }
    );

    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("orders").doc(refOrder.id).set(
      {
        "orderId": refOrder.id,
      }
    );

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart").get();

    for(DocumentSnapshot doc in snapshot.docs){
      doc.reference.delete();
    }

    products.clear();
    discountPercentage = 0;
    couponCode = null;
    isLoading = false;
    notifyListeners();

    return refOrder.id;

  }

  void _loadCartItem() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart").get();

    products = snapshot.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

}