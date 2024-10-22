import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  late String category;
  late String id;

  late String description;
  late String title;
  late double price;
  late String image;

  late List<ColorData> colors;

  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.id;
    title = snapshot.get('title');
    description = snapshot.get('description');
    price = snapshot.get('price') + 0.0;
    image = snapshot.get('image');
    colors = (snapshot.get('colors') as List<dynamic>).map(
        (colorDoc) => ColorData.fromMap(colorDoc as Map<String, dynamic>)
    ).toList();
  }

  Map<String, dynamic> toResumeMap(){
    return {
      'title': title,
      'description': description,
      'price': price,
    };
  }
}

class ColorData {
  late String colorHex;
  late String colorTitle;
  late List<String> images;

  ColorData.fromMap(Map<String, dynamic> map){
    colorHex = map['colorHex'] ?? '';
    colorTitle = map['colorTitle'] ?? '';
    images = List<String>.from(map['images'] ?? []);

  }
}
