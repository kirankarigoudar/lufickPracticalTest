import 'package:flutter/cupertino.dart';

class Rates {
  List<RateItems> rates;

  Rates({@required rates}) {
    this.rates = rates;
  }

  factory Rates.fromJson(Map<String, dynamic> json) {
    List<RateItems> rateItemsList = [];

    try {
      json["rates"].forEach((key, value) {
        rateItemsList.add(RateItems(country: key, currency: value));
      });
    } catch (e) {
      print("error while getting rates value from json value $e");
    }
    return Rates(rates: rateItemsList);
  }
}

class RateItems {
  String country;
  double currency;

  RateItems({@required country, @required currency}) {
    this.country = country;
    this.currency = currency;
  }

  factory RateItems.fromJson(Map<String, dynamic> json) {
    return RateItems(country: json['country'], currency: json['courrency']);
  }
}
