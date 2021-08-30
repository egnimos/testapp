class Product {
  final int productID;
  final String productName;
  final String category;
  final int price;

  //construct
  Product({
    required this.productID,
    required this.productName,
    required this.category,
    required this.price,
  });

  factory Product.fromJson(Map data) => Product(
        productID: data["productID"],
        productName: data["productName"],
        category: data["category"],
        price: data["price"],
      );
}
