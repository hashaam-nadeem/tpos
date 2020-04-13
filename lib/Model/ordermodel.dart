class OrderModel {
  final bool withError;
  final String shortMessage;
  final List<OrderResult> result;

  OrderModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      withError: json['WithError'],
      result:
          (json['Result'] as List).map((e) => OrderResult.fromJson(e)).toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class OrderResult {
  int id;
  String orderNumber;
  String customerName;
  String customerNumber;
  int paymentMethod;
  String date;
  var totalBill;
  int status;
  List<LineDetail> lineDetail;

  OrderResult(
      {this.status,
      this.paymentMethod,
      this.orderNumber,
      this.lineDetail,
      this.date,
      this.customerName,
      this.id,
      this.customerNumber,
      this.totalBill});

  factory OrderResult.fromJson(Map<String, dynamic> json) {
    return OrderResult(
      lineDetail: (json['LineDetails'] as List)
          .map((e) => LineDetail.fromJson(e))
          .toList(),
      id: json['Id'] ?? 0,
      orderNumber: json['Number'] ?? 0,
      customerName: json['CustomerName'] ?? "",
      customerNumber: json['CustomerNumber'] ?? "",
      paymentMethod: json['PaymentMethod'] ?? "",
      date: json['Date'] ?? "",
      totalBill: json['TotalBill'] ?? 0.0,
      status: json['Status'] ?? 0,
    );
  }
}

class LineDetail {
  int id;
  String productName;
  String productCode;
  String imageUrl;
  var price;
  var qty;
  var total;
  LineDetail(
      {this.id,
      this.imageUrl,
      this.price,
      this.productCode,
      this.productName,
      this.qty,
      this.total});

  factory LineDetail.fromJson(Map<String, dynamic> json) {
    return LineDetail(
      id: json['Id']??"",
      imageUrl: json['ProductImageUrl']??"",
      price: json['Price']??"",
      productCode: json['ProductCode']??"",
      productName: json['ProductName']??"",
      qty: json['Qty']??"",
      total: json['Total']??"",
    );
  }
}
