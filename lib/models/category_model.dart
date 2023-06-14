// class Category {
//   String id;
//   String categoryName;

//   Category({
//     required this.id,
//     required this.categoryName,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'],
//       categoryName: json['categoryName'],
//     );
//   }
// }

import 'package:flutter/material.dart';

class Category {
  Color begin;
  Color end;
  String category;
  String image;

  Category(this.begin, this.end, this.category, this.image);
}
