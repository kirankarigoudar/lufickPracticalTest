import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:http_interceptor/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:lufick/models/rates.dart';
import 'network_data_exceptions.dart';


class HttpService {
  static const String baseUrl =
      "http://api.exchangeratesapi.io";

  http.Client client = HttpClientWithInterceptor.build(interceptors: [
    HttpInterceptor()
  ]);

  Future<Rates> fetchCountryCurrencyRates() async {
    String url = "$baseUrl/latest";
    Rates rates;
    print("Fetching  country currency rates");
    final response = await client.get(url);
    if (response.statusCode == 200) {
      print("response data => ${response.body}");
      try {

        rates =  Rates.fromJson(json.decode(response.body));

      } catch (e) {
        print("Error while parsing  country currency rates: $e");
        throw NetworkDataException(NetworkDataException.CODE_PARSE_ERROR,
            "Oops, something went wrong");
      }
    } else {
      if (response.statusCode == 401) {
        throw NetworkDataException(response.statusCode,
            "Unauthorized Error(E00${response.statusCode})");
      } else {
        throw NetworkDataException(
            response.statusCode, "Unable to load currency rates");
      }
    }
    return rates;
  }
}

class HttpInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
      data.headers["Content-type"] = "application/json";
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async => data;
}
