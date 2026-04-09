
class TotalExpanseModel {
  final bool withError;
  final String shortMessage;
  final List<ExpanseResult> result;

  TotalExpanseModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory TotalExpanseModel.fromJson(Map<String, dynamic> json) {
    return TotalExpanseModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => ExpanseResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class ExpanseResult {
   int id;
   String name;
   String date;
   var qty;
   var price;
   var total;
  String img;

  ExpanseResult({
    this.id,
    this.name,
    this.img,
   this.date,this.total,this.price,this.qty
  });

  factory ExpanseResult.fromJson(Map<String, dynamic> json) {
    return ExpanseResult(
      id: json['Id']??0,
      name: json['AccountHeadName'] ?? "",
      date: json['Date']??"",
      price: json['Price'] ?? 0.0,
      total: json['Total']??0,
      qty: json['Qty'] ?? 0,
      img: json['ImageFileUrl']??"",
      //totalSale: json['TotalSale'] ??0,
     
    );
  }
}

