
class PinsModel {
  final bool withError;
  final String shortMessage;
  final List<PinResult> result;

  PinsModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory PinsModel.fromJson(Map<String, dynamic> json) {
    return PinsModel(
      withError: json['WithError'],
      result: (json['Result'] as List)
          .map((e) => PinResult.fromJson(e))
          .toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class PinResult {
   int id;
  String pin;
  

  PinResult({
   this.pin,this.id 
    });

  factory PinResult.fromJson(Map<String, dynamic> json) {
    return PinResult(
      id: json['Id']??0,
      pin: json['Pin'] ?? 0,
     
    );
  }
}

