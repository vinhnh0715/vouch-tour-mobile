class Product {
  String id;
  String productName;
  int resellPrice;
  int retailPrice;
  String status;
  List<Image> images;
  Supplier supplier;
  Category category;

  Product({
    required this.id,
    required this.productName,
    required this.resellPrice,
    required this.retailPrice,
    required this.status,
    required this.images,
    required this.supplier,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Image> images = (json['images'] as List)
        .map((imageJson) => Image.fromJson(imageJson))
        .toList();
    Supplier supplier = Supplier.fromJson(json['supplier']);
    Category category = Category.fromJson(json['category']);

    return Product(
      id: json['id'],
      productName: json['productName'],
      resellPrice: json['resellPrice'],
      retailPrice: json['retailPrice'],
      status: json['status'],
      images: images,
      supplier: supplier,
      category: category,
    );
  }
}

class Image {
  String id;
  String fileURL;
  String fileName;
  String productId;

  Image({
    required this.id,
    required this.fileURL,
    required this.fileName,
    required this.productId,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      fileURL: json['fileURL'],
      fileName: json['fileName'],
      productId: json['productId'],
    );
  }
}

class Supplier {
  String id;
  String supplierName;
  String address;
  String phoneNumber;
  String adminId;

  Supplier({
    required this.id,
    required this.supplierName,
    required this.address,
    required this.phoneNumber,
    required this.adminId,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      supplierName: json['supplierName'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      adminId: json['adminId'],
    );
  }
}

class Category {
  String id;
  String categoryName;

  Category({
    required this.id,
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['categoryName'],
    );
  }
}
