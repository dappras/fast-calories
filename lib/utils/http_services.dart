import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class HttpService {
  static final HttpService _instance = HttpService.internal();
  HttpService.internal();
  factory HttpService() => _instance;

  final LocalStorage storage = LocalStorage('fast-calories');
  Map<String, String> headers = {};
  final JsonDecoder _decoder = const JsonDecoder();
  static const _baseUrl = "http://10.0.2.2:3000/";

  Future<dynamic> post(String desturl,
      {Map<String, String> headers = const {"": ""}, body, encoding}) async {
    body ??= {};
    var authKey = storage.getItem("token");

    Map<String, String> requestHeaders = {
      "Content-type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      "auth-token": authKey ?? '',
    };
    return http
        .post(Uri.parse(_baseUrl + desturl),
            body: json.encode(body),
            headers: requestHeaders,
            encoding: encoding)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }

      return _decoder.convert(response.body);
    }, onError: (error) {
      throw Exception(error.toString());
    });
  }
}
