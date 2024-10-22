import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/datas/product_data.dart';

class CartProduct {
  late String cartId;

  late String category;
  late String productId;

  late int quantity;
  late String? color;

  ProductData? productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    cartId = document.id;
    category = document.get('category');
    productId = document.get('productId');
    quantity = document.get('quantity');
    color = document.get('color');
  }

  Map<String, dynamic> toMap(){
    return {
      'category': category,
      'productId': productId,
      'quantity': quantity,
      'color': color,
      'product': productData?.toResumeMap(),
    };
  }

}