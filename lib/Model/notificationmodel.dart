
class NotificationModel {
  final bool withError;
  final String shortMessage;
  final List<NotificationResult> result;

  NotificationModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => NotificationResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class NotificationResult {
   int id;
   int prouctId;
   String title;
   String message;
   String date;
   int type;
   int orderId;
   
  

  NotificationResult({
    this.id,
        this.date,
        this.message,this.orderId,this.prouctId,this.title,this.type
  });

  factory NotificationResult.fromJson(Map<String, dynamic> json) {
    return NotificationResult(
      id: json['Id']??0,
      title: json['Title'] ?? "",
      message: json['Message'] ?? "",
      date: json['Date'] ?? "",
      type: json['Type'] ?? 0,
       orderId: json['OrderId'] ?? 0,
       prouctId: json['ProductId'] ?? 0,
    );
  }
}

