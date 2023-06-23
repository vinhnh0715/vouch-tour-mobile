import 'package:flutter/material.dart';

import 'dart:math';

class Category {
  String id;
  Color begin;
  Color end;
  String categoryName;
  String image;

  Category({
    required this.id,
    required this.begin,
    required this.end,
    required this.categoryName,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final Random random = Random();
    final Color begin = Color(0xFF000000 + random.nextInt(0xFFFFFF));
    final Color end = Color(0xFF000000 + random.nextInt(0xFFFFFF));

    //final String image = 'lib/assets/images/tour_logo3.png';

    return Category(
      id: json['id'],
      begin: begin,
      end: end,
      categoryName: json['categoryName'],
      image: json['url'],
    );
  }
}
