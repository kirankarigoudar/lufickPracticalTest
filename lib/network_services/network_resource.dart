import 'package:flutter/material.dart';

class NetworkResource<T>{
  T _data;
  bool isFetching = false;
  int _errorCode = -1;
  String errorMessage;

  NetworkResource({@required data}) {
    _data = data;
    this.isFetching = false;
    clearError();
  }

  T get data => _data;

  int get errorCode => _errorCode + 250;

  set(T data) {
    this._data = data;
  }

  setLoading(bool isLoading) {
    this.isFetching = isLoading;
    this.errorMessage = "";
    this._errorCode = -1;
  }

  setError(int code, String message) {
    this.isFetching = false;
    this._errorCode = code;
    this.errorMessage = message;
  }

  clearError() {
    this._errorCode = -1;
    this.errorMessage = null;
  }

  bool hasError() => _errorCode != -1;
}