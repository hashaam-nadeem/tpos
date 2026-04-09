
class SearchModel {
  final bool withError;
  final String shortMessage;
  final List<SearchResult> result;

  SearchModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => SearchResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class SearchResult {
   int id;
   String name;
   String imagePath;
   var productCode;
   double actualPrice;
   var salePrice;
  

  SearchResult({
    this.id,
    this.name,
    this.actualPrice,this.imagePath,this.productCode,this.salePrice   
    });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['Id']??0,
      name: json['ProductName'] ?? "",
      salePrice: json['SalePrice'] ?? "",
      actualPrice: json['ActualPrice'] ?? "",
      imagePath: json['ProductImageUrl'] ?? "",
       productCode: json['ProductCode'] ?? "",
    );
  }
}

