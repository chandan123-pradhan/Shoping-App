import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';

import 'CustomException.dart';
import 'NetworkConstant.dart';

class ApiProvider {
  final String url = NetworkConstant.URL;
  final String auth_token =
      'eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz';

  Future<dynamic> postAfterAuth(Map parameter) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "authorization": "Bearer " + auth_token,
          },
          body: parameter);
     

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic _responseFromStream(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
