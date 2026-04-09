
class HeadersModel {
  final bool withError;
  final String shortMessage;
  final List<HeadersResult> result;

  HeadersModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory HeadersModel.fromJson(Map<String, dynamic> json) {
    return HeadersModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => HeadersResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class HeadersResult {
   int id;
   String name;
   int type;
  

  HeadersResult({
    this.id,
    this.name,
    this.type
  });

  factory HeadersResult.fromJson(Map<String, dynamic> json) {
    return HeadersResult(
      id: json['Id']??0,
      name: json['Name'] ?? "",
      type: json['HeadType'] ?? "",
      
    );
  }
}

