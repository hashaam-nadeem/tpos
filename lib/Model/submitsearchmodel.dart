
class SubmitModel {
  final bool withError;
  final String shortMessage;
  final List<SearchResult> result;

  SubmitModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory SubmitModel.fromJson(Map<String, dynamic> json) {
    return SubmitModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => SearchResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class SearchResult {
   var id;
   var name;
   var imagePath;
   var productCode;
   var actualPrice;
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

