class BundleModel {
  final bool withError;
  final String shortMessage;
  final List<BundleResult> result;

  BundleModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory BundleModel.fromJson(Map<String, dynamic> json) {
    return BundleModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => BundleResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class BundleResult {
  var id;
  String name;
  var code;
  String description;
  String specification;
  var actualPrice;
  var salePrice;
  var qty;
  var totalDiscount;
  var gst;
  bool withDiscount;
  bool isDiscountPercentage;
  bool isProductVisible;
  var type;
  var categoryId;
  String categoryName;
   var rating;
  var minOrder;
  String imagePath;

  BundleResult({
    this.id,
    this.name,
    this.rating,
    this.description,
    this.qty,
    this.specification,
    this.salePrice,
    this.withDiscount,
    this.actualPrice,
    this.categoryId,
    this.categoryName,
    this.code,
    this.gst,
    this.imagePath,
    this.isDiscountPercentage,
    this.isProductVisible,
    this.minOrder,
    this.totalDiscount,
    this.type,
  });

  factory BundleResult.fromJson(Map<String, dynamic> json) {
    return BundleResult(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? "",
      description: json['Description'] ?? "",
       code: json['Code'] ?? 0,
      specification: json['Specification'] ?? "",
      imagePath: json['FeatureImageUrl'] ?? "",
       actualPrice: json['ActuallPrice'] ?? 0,
      salePrice: json['SalePrice'] ?? "",
      gst: json['GST'] ?? "",
       minOrder: json['MinOrder'] ?? 0,
      totalDiscount: json['TotalDiscount'] ?? "",
      withDiscount: json['WithDiscount'] ?? "",
       isDiscountPercentage: json['IsDiscountPercentage'] ?? "",
       isProductVisible: json['IsProductVisible'] ?? 0,
      type: json['Type'] ?? "",
      categoryId: json['CategoryId'] ?? "",
       categoryName: json['CategoryName'] ?? "",
       rating: json['Rating'] ?? 0.0,
        qty: json['Qty'] ?? 0.0,
    );
  }
}
