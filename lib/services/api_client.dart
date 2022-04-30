import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mash_flutter/services/api.dart';

class ApiClient extends GetxService {
  Future<String> getData(String uri, {Map<String, dynamic>? query}) async {
    http.Response response = await http.get(Uri.parse(Api.BASE_URL + uri));

    developer.log('Response => ${response.body}');

    return response.body;
  }

  Future<String> putData(String uri, dynamic body) async {
    developer.log('Body => $body');

    http.Response response = await http.put(
      Uri.parse(Api.BASE_URL + uri),
      body: jsonEncode(body),
      headers: {'accept': '*/*', 'Content-Type': 'application/json'},
    );

    developer.log('Response => ${(response.body)}');

    return response.body;
  }

  Future<String> postData(String uri, dynamic body) async {
    developer.log('Body => $body');

    http.Response response = await http.post(
      Uri.parse(Api.BASE_URL + uri),
      body: jsonEncode(body),
      headers: {'accept': '*/*', 'Content-Type': 'application/json'},
    );

    developer.log('Response => ${jsonDecode(response.body)}');

    return response.body;
  }
}
