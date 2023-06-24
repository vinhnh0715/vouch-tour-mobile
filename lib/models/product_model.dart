class Product {
  String id;
  String productName;
  int resellPrice;
  int retailPrice;
  String description;
  String status;
  List<Image> images;
  Supplier supplier;
  Category category;
  // MORE
  bool isSelected;
  int qty;

  Product({
    required this.id,
    required this.productName,
    required this.resellPrice,
    required this.retailPrice,
    required this.description,
    required this.status,
    required this.images,
    required this.supplier,
    required this.category,
    this.isSelected = false,
    this.qty = 0,
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
      description: json['description'],
      status: json['status'],
      images: images,
      supplier: supplier,
      category: category,
      isSelected: false,
      qty: 0,
    );
  }

  Product copyWith({
    String? id,
    String? productName,
    int? resellPrice,
    int? retailPrice,
    String? description,
    String? status,
    List<Image>? images,
    Supplier? supplier,
    Category? category,
    bool? isSelected,
    int? qty,
  }) {
    return Product(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      resellPrice: resellPrice ?? this.resellPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      description: description ?? this.description,
      status: status ?? this.status,
      images: images ?? this.images,
      supplier: supplier ?? this.supplier,
      category: category ?? this.category,
      isSelected: isSelected ?? this.isSelected,
      qty: qty ?? this.qty,
    );
  }
}

class Image {
  //String id;
  String fileURL;
  String fileName;
  //String productId;

  Image({
    //required this.id,
    required this.fileURL,
    required this.fileName,
    //required this.productId,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      //id: json['id'],
      fileURL: json['fileURL'],
      fileName: json['fileName'],
      //productId: json['productId'],
    );
  }
}

class Supplier {
  String id;
  String supplierName;
  String address;
  String phoneNumber;
  String email;
  // String adminId;

  Supplier({
    required this.id,
    required this.supplierName,
    required this.address,
    required this.phoneNumber,
    required this.email,
    //required this.adminId,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      supplierName: json['supplierName'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      //adminId: json['adminId'],
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
