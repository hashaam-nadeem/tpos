
class TotalSalesModel {
  final bool withError;
  final String shortMessage;
  final List<SalesResult> result;

  TotalSalesModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory TotalSalesModel.fromJson(Map<String, dynamic> json) {
    return TotalSalesModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => SalesResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class SalesResult {
   int id;
   String number;
   int paymentMethod;
   String date;
   var qty;
   var price;
   var total;
  String img;

  SalesResult({
    this.id,
    this.img,
   this.date,this.total,this.price,this.qty
  });

  factory SalesResult.fromJson(Map<String, dynamic> json) {
    return SalesResult(
      id: json['Id']??0,
      date: json['Date']??"",
      price: json['Price'] ?? 0.0,
      total: json['Total']??0,
      qty: json['Qty'] ?? 0,
      img: json['ImageFileUrl']??"",
      //totalSale: json['TotalSale'] ??0,
     
    );
  }
}

