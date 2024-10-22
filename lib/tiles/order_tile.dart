import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .doc(orderId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {

                int status = snapshot.data?['status'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Código do pedido: ${snapshot.data!.id}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(_buildProductsText(snapshot.data)),
                    SizedBox(
                      height: 4,
                    ),
                    Text("Status do Pedido: ", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircleStatus("1", "Preparação", status, 1),
                        Container(
                          height: 1,
                          width: 40,
                          color: Colors.grey[500]
                        ),
                        _buildCircleStatus("2", "Transporte", status, 2),
                        Container(
                            height: 1,
                            width: 40,
                            color: Colors.grey[500]
                        ),
                        _buildCircleStatus("3", "Entrega", status, 3),
                      ],
                    )
                  ],
                );
              }
            }),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot? snapshot) {
    String text = "Descrição:\n";
    for (LinkedHashMap product in snapshot?.get('products')) {
      text +=
          "${product['quantity']}x ${product['product']['title']} ${(product['color']) ?? ''} ${product['product']['price'].toStringAsFixed(2).replaceFirst('.', ',')}\n";
    }

    text +=
        "Total: R\$ ${snapshot?.get('totalPrice').toStringAsFixed(2).replaceFirst('.', ',')}";

    return text;
  }

  Widget _buildCircleStatus(
      String title, String subtitle, int status, int thisStatus) {
    Color? backgroundCircle;
    Widget child;

    if (status < thisStatus) {
      backgroundCircle = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backgroundCircle = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backgroundCircle = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backgroundCircle,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
