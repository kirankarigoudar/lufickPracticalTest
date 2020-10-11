import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lufick/models/rates.dart';
import 'package:lufick/network_services/api_services.dart';
import 'package:lufick/network_services/network_data_exceptions.dart';
import 'package:lufick/network_services/network_resource.dart';
import 'package:lufick/utils/constants.dart';

class DataService extends ChangeNotifier {

  FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  DataService.initialDataLoad() {
    this.setInitialDate();
    this.fetchCurrencyRates();
  }

  NetworkResource _currencyRates =
      NetworkResource<List<RateItems>>(data: List<RateItems>());

  NetworkResource get currencyRates => _currencyRates;

  String _lastTimeRefreshDate;

  String get lastTimeRefreshDate => _lastTimeRefreshDate;

  HttpService _httpService = HttpService();

  fetchCurrencyRates({bool notify = true}) async {
    try {
      this._currencyRates.clearError();
      this._currencyRates.setLoading(true);
      if (notify) notifyListeners();
      Rates ratesObj = await _httpService.fetchCountryCurrencyRates();
      if (ratesObj.rates.isEmpty) {
        this._currencyRates.setLoading(false);
        if (notify) notifyListeners();
        this._currencyRates.setError(204, "No data found");
        if (notify) notifyListeners();
      } else {
        _lastTimeRefreshDate = getLocalDate();
        this._currencyRates.setLoading(false);
        if (notify) notifyListeners();
        this._currencyRates.data.clear();
        this._currencyRates.data.addAll(ratesObj.rates);
      }
      if (notify) {
        notifyListeners();
      }
    } on NetworkDataException catch (e) {
      this._currencyRates.setError(e.code, e.message);
      if (notify) notifyListeners();
    } catch (e) {
      this._currencyRates.setError(NetworkDataException.CODE_UNKNOWN_ERROR,
          "Oops, something went wrong");
      if (notify) notifyListeners();
      print(" Country currency connot be fetched due to =>: $e");
    }
  }

  String getLocalDate() {
    DateTime dateTime = DateTime.now();
    String localDate = "";
    final df = new DateFormat('dd/MM/yy, hh:mm a');
    try {
      localDate = df.format(dateTime);
    } catch (e) {
      print("error while prase dateTime $e");
    }
    saveLastRefreshToLocal(localDate);
    return localDate;
  }

  saveLastRefreshToLocal(String dateTime) async {
    await _secureStorage.write(key: Constants.KEY_LAST_REFRESH_DATE, value: dateTime);
  }

  setInitialDate() async {
   _lastTimeRefreshDate = await _secureStorage.read(key:Constants.KEY_LAST_REFRESH_DATE) ?? "";
   notifyListeners();
  }
}
