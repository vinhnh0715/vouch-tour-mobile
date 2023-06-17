class CartItem {
  String id;
  String cartId;
  String productId;
  String productName;
  String supplierId;
  String supplierName;
  String categoryName;
  int actualPrice;
  int supplierPrice;
  String description;
  List<CartItemImages> images; // Renamed class name to CartItemImages

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.supplierId,
    required this.supplierName,
    required this.categoryName,
    required this.actualPrice,
    required this.supplierPrice,
    required this.description,
    required this.images,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    List<CartItemImages> images = (json['images'] as List)
        .map((imageJson) => CartItemImages.fromJson(imageJson))
        .toList();

    return CartItem(
      id: json['id'],
      cartId: json['cartId'],
      productId: json['productId'],
      productName: json['productName'],
      supplierId: json[
          'supplerId'], // Corrected spelling: "supplierId" instead of "supplerId"
      supplierName: json['supplierName'],
      categoryName: json['categoryName'],
      actualPrice: json['actualPrice'],
      supplierPrice: json[
          'suppleirPrice'], // Corrected spelling: "supplierPrice" instead of "suppleirPrice"
      description: json['description'],
      images: images,
    );
  }
}

class CartItemImages {
  // Renamed class name to CartItemImages
  String fileName;
  String fileURL;

  CartItemImages({
    required this.fileName,
    required this.fileURL,
  });

  factory CartItemImages.fromJson(Map<String, dynamic> json) {
    return CartItemImages(
      fileName: json['fileName'],
      fileURL: json['fileURL'],
    );
  }
}
