
class PinsmoduleModel {
  final bool withError;
  final String shortMessage;
  final List<PinmoduleResult> result;

  PinsmoduleModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory PinsmoduleModel.fromJson(Map<String, dynamic> json) {
    return PinsmoduleModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => PinmoduleResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class PinmoduleResult {
   int id;
  String moduleName;
  bool isAssign;

  

  PinmoduleResult({
   this.isAssign,this.id,
   this.moduleName 
    });

  factory PinmoduleResult.fromJson(Map<String, dynamic> json) {
    return PinmoduleResult(
      id: json['Id']??0,
      moduleName: json['ModuleName'] ?? "",
      isAssign: json['IsAssigned'] ?? "",
    );
  }
}

