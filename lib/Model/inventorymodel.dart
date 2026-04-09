
class InventoryModel {
  final bool withError;
  final String shortMessage;
  final List<InventoryResult> result;

  InventoryModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => InventoryResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class InventoryResult {
   int id;
   String name;
   int code;
   var actualPrice;
   var salePrice;
   var qtyStock;
   var totalPurchase;
   var totalSale;
  

  InventoryResult({
    this.id,
    this.name,
    this.actualPrice,this.code,this.qtyStock,this.salePrice,this.totalPurchase,this.totalSale
  });

  factory InventoryResult.fromJson(Map<String, dynamic> json) {
    return InventoryResult(
      id: json['Id']??0,
      name: json['Name'] ?? "",
      code: json['Code']??0,
      actualPrice: json['ActuallPrice'] ?? "",
      salePrice: json['SalePrice']??0,
      qtyStock: json['QtyInStock'] ?? 0,
      totalPurchase: json['TotalPurchase']??0,
      totalSale: json['TotalSale'] ??0,
     
    );
  }
}

