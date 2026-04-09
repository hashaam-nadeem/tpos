
class CartModel {
  final bool withError;
  final String shortMessage;
  final List<CartResult> result;

  CartModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => CartResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class CartResult {
   int id;
   int productId;
   String name;
   String imagePath;
   var price;
   var lineTotal;
   var qty;
  

  CartResult({
    this.id,
    this.name,
    this.imagePath,this.price,this.qty,this.lineTotal,this.productId
  });

  factory CartResult.fromJson(Map<String, dynamic> json) {
    return CartResult(
      id: json['Id']??0,
      name: json['ProductName'] ?? "",
      productId: json['ProductId'] ?? "",
      price: json['Price'] ?? "",
      imagePath: json['ProductImageUrl'] ?? "",
       qty: json['Qty'] ?? "",
       lineTotal: json['LineTotal'] ?? "",
    );
  }
}

