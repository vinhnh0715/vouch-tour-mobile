import 'product_model.dart';

class Menu {
  final String id;
  final String title;
  final String tourGuideId;
  final int quantity;
  final String status;
  final List<Product> products;

  Menu({
    required this.id,
    required this.title,
    required this.tourGuideId,
    required this.quantity,
    required this.status,
    required this.products,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      title: json['title'],
      tourGuideId: json['tourGuideId'],
      quantity: json['quantity'],
      status: json['status'],
      products: json['products'] != null
          ? List<Product>.from(
              json['products'].map((product) => Product.fromJson(product)),
            )
          : [],
    );
  }
}
