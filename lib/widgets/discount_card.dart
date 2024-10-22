import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';

class DiscountCard extends StatefulWidget {
  const DiscountCard({super.key});

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  Color _borderColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        iconColor: Theme.of(context).primaryColor,
        title: Text(
          "Cupom de desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _borderColor, width: 2),
                  ),
                  hintText: "Digite seu cupom"),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) {
                if (!text.isEmpty) {
                  FirebaseFirestore.instance
                      .collection("coupons")
                      .doc(text)
                      .get()
                      .then((docSnap) {
                    print(docSnap);
                    if (docSnap.data() != null) {
                      setState(() {
                        _borderColor = Theme.of(context).primaryColor;
                      });
                      CartModel.of(context).setCoupon(text, docSnap.get("percent"));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Desconto de ${docSnap.get("percent")}% aplicado com sucesso!"),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );
                    } else {
                      CartModel.of(context).setCoupon(null, 0);
                      setState(() {
                        _borderColor = Colors.redAccent;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Cupom inválido!"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
