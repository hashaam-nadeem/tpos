
class JournalModel {
  final bool withError;
  final String shortMessage;
  final List<JournalResult> result;

  JournalModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => JournalResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class JournalResult {
   int id;
   int accountId;
   String name;
   String date;
   String summary;
   String imageUrl;
   String num;
   String accountHeadName;
   double qty;
   double price;
   double total;
  

  JournalResult({
    this.id,
    this.name,
    this.price,this.total,this.accountHeadName,this.accountId,this.date,this.imageUrl,this.num,this.qty,this.summary
  });

  factory JournalResult.fromJson(Map<String, dynamic> json) {
    return JournalResult(
      id: json['Id']??0,
      name: json['Title'] ?? "",
       accountHeadName: json['AccountHeadName']??"",
      accountId: json['AccountHeadId'] ?? 0,
        summary: json['Summary']??"",
      num: json['Number'] ?? "",
        qty: json['Qty']??0.0,
      total: json['Total'] ?? 0.0,
        price: json['Price']??0.0,
      imageUrl: json['ImageFileUrl'] ?? "",
        date: json['Date']??"",
     
      
    );
  }
}

