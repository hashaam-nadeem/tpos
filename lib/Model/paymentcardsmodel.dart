
class PaymentCardsModel {
  final bool withError;
  final String shortMessage;
   List<CardResult> result;
  PaymentCardsModel({this.withError, this.result, this.shortMessage,});

  factory PaymentCardsModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardsModel(
      withError: json['WithError'],
      result: (json['Result'] as List).map((e) => CardResult.fromJson(e)).toList(),
      shortMessage: json['ShortMessage'],
    );
  }
}

class CardResult {
  var cardNum;
  var cardType;
  var holderName;
  var cvv;
  var expiryYear;
  var expiryMonth;
  CardResult({
   this.cardType,this.cardNum,this.cvv,this.expiryMonth,this.expiryYear,this.holderName
  });

  factory CardResult.fromJson(Map<String, dynamic> json) {
    return CardResult(
      cardType: json['CardType']??"",
      cardNum: json['CardNumber']??"",
      cvv: json['CVV']??"",
        expiryMonth: json['ExpiryMonth']??"",
      expiryYear: json['ExpiryYear']??"",
      holderName: json['HolderName']??"",
     
    );
  }
}
