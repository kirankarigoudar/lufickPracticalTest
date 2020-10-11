class NetworkDataException implements Exception {

  static const int CODE_PARSE_ERROR = 1001;
  static const int CODE_UNKNOWN_ERROR = 1002;

  int code;
  String message;
  NetworkDataException(this.code, this.message);
}