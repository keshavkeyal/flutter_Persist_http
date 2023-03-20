import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_persist_http/src/exception.dart';
class HttpMap {
  static Future<dynamic> getHttpMap(String url) async {
    String resp;
    try {
      final response = await http.get(url);
      switch (response.statusCode) {
        case 200:
          print(response.statusCode);
          print("getting data" + response.body);
          resp = response.body;
          break;
        case 400:
          print(response.body);
          throw BadRequestException(response.body.toString());
          // print(response.body);
          break;
        case 401:
          print(response.body);
          break;
        case 403:
          print(response.body);
          throw UnauthorisedException(response.body.toString());
          break;
        case 500:
          print(response.body);
          break;
        default:
          print(response.body);
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      }
    } catch (e) {
      print('Error ${e.toString()}');
    }
    final parsed =HttpMap.responseToMap(resp);
    return parsed;
  }

  static Future<dynamic> postHttpMap(
      String url, Map<String, dynamic> body) async {
    String resp;
   await http.post(url, body: jsonEncode(body)).then((result) {
      switch (result.statusCode) {
        case 200:
          resp = result.body;
          print(result.statusCode);
          print("getting data" + result.body);
          break;
        // return result.body;
        case 400:
          resp = result.body;
          throw BadRequestException(result.body.toString());
          break;
        case 401:
          break;
        case 403:
          throw UnauthorisedException(result.body.toString());
          break;
        case 500:
          break;
        default:
          resp = result.body;
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${result.statusCode}');
      }
    }).catchError((onError) {
      print(onError);
    });
   final parsed =HttpMap.responseToMap(resp);
    return parsed;
  }

  static Future<dynamic> httppostResponse(
      String url, Map<String, dynamic> body) async {
    String resp;
    print(body);
   await http.post(url, body: jsonEncode(body)).then((result) {
      switch (result.statusCode) {
        case 200:
          resp = result.body;
          print(result.statusCode);
          print("getting data" + result.body);
          break;
        case 400:
          resp = result.body;
          throw BadRequestException(result.body.toString());
          break;
        case 401:
          break;
        case 403:
          throw UnauthorisedException(result.body.toString());
          break;
        case 500:
          break;
        default:
          resp = result.body;
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${result.statusCode}');
      }
    }).catchError((onError) {
      print(onError);
    });
    return resp;
  }
  static Future<dynamic> httpGetResponse(String url) async {
    String resp;
   await http.get(url).then((result) {
      switch (result.statusCode) {
        case 200:
          resp = result.body;
          print(result.statusCode);
          print("getting data" + result.body);
          break;
        case 400:
          resp = result.body;
          throw BadRequestException(result.body.toString());
          break;
        case 401:
          break;
        case 403:
          throw UnauthorisedException(result.body.toString());
          break;
        case 500:
          break;
        default:
          resp = result.body;
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${result.statusCode}');
      }
    }).catchError((onError) {
      print(onError);
    });
    return resp;
  }
  static dynamic responseToMap(String resp)  {
    final parsed = json.decode(resp).cast<Map<String, dynamic>>();
    return parsed;
  }  
}