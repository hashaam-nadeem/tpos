
class SupplierSearchModel {
  final bool withError;
  final String shortMessage;
  final List<SupplierSearchResult> result;

  SupplierSearchModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory SupplierSearchModel.fromJson(Map<String, dynamic> json) {
    return SupplierSearchModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => SupplierSearchResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class SupplierSearchResult {
   int id;
   String name;
   var productCode;
   String imagePath;
   var actualPrice;
   var salePrice;
  

  SupplierSearchResult({
    this.id,
    this.name,
   this.salePrice,this.imagePath,this.actualPrice,this.productCode
  });

  factory SupplierSearchResult.fromJson(Map<String, dynamic> json) {
    return SupplierSearchResult(
      id: json['Id']??0,
      name: json['ProductName'] ?? "",
      productCode: json['ProductCode'] ?? 0,
      imagePath: json['ProductImageUrl'] ?? "",
      actualPrice: json['ActualPrice'] ?? 0.0,
       salePrice: json['SalePrice'] ?? 0.0,
    );
  }
}

