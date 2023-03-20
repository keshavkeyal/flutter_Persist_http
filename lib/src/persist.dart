import 'dart:io';
import 'dart:convert';
import 'package:flutter_persist_http/flutter_persist_http.dart';
import 'package:http/http.dart' as http;
class Persist {
  File jsonFile;
  final Directory dir;
  String jsonFileName;
  bool fileExists = false;
  final String apiName;
  Persist(this.dir, this.apiName) {
    this.jsonFileName = apiName + ".json";
    jsonFile = File(dir.path + "/" + jsonFileName);
    fileExists = jsonFile.existsSync();
    if (fileExists) {
      print(jsonDecode(jsonFile.readAsStringSync()));
    } else {
      print("file not created");
    }
  }
  void createFile(String content, Directory dir, String fileName) {
    print("Creating file!");
    File file = File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(content);
  }
  void saveJsonData(String content) {
    print("Writing to file!");
    if (fileExists) {
      print("File exists");
      print("file writing data" + content);
      jsonFile.writeAsStringSync(content);
      print("save data");
    } else {
      print("File does not exist!");
      createFile(content, dir, jsonFileName);
    }
  }
  Future<String> saveHttpGet(String url) async {
    String resp;
    try {
      final response = await http.get(url);
      switch (response.statusCode) {
        case 001:
          resp = response.body;
          print(response.statusCode);
          print("saving your data..." + response.body);
          saveJsonData(response.body);
          break;
        case 200:
          resp = response.body;
          print(response.statusCode);
          print("saving your data..." + response.body);
          saveJsonData(response.body);
          //return response.body;
          break;
        case 400:
          resp = response.body;
          throw BadRequestException(response.body.toString());
          break;
        case 401:
          resp = response.body;
          break;
        case 403:
          resp = response.body;
          throw UnauthorisedException(response.body.toString());
          break;
        case 500:
          resp = response.body;
          break;
        default:
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      }
    } catch (e) {
      print('Error ${e.toString()}');
    }
    return resp;
  }
  Future<String> saveHttpPost(String url, Map<String, dynamic> body) async {
    String resp;
    print(body);
    http.post(url, body: jsonEncode(body)).then((result) {
      switch (result.statusCode) {
        case 200:
          resp = result.body;
          print(result.statusCode);
          print("saving your data..." + result.body);
          saveJsonData(result.body);
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
    return resp;
  }
/*  Future<String> getData() async {
    String k;
    if(fileExists)
    k= json.decode(jsonFile.readAsStringSync());
  
  else
  print("file not found");
  return k;
  }*/
  Future<dynamic> getMappedDataFromStorage() async {
    if (fileExists) {
      final parsed =
          json.decode(jsonFile.readAsStringSync()).cast<Map<String, dynamic>>();
      return parsed;
    }
    else{
    print("file not found");
    return "file not found";
    }
  }
  void addNewListMappdedData(List<Map<String, dynamic>> map) {
    print("Writing to file!");
    if (fileExists) {
      List<Map<String, dynamic>> jsonFileContent =
          json.decode(jsonFile.readAsStringSync()).cast<Map<String, dynamic>>();
      jsonFileContent.addAll(map);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
      print("save data");
    } else {
      print("File does not exist!");
      createFile(jsonEncode(map), dir, jsonFileName);
    }
  }
  void addNewMappdedData(Map<String, dynamic> map) {
    print("Writing to file!");
    if (fileExists) {
      List<Map<String, dynamic>> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.add(map);
      jsonFile.writeAsStringSync(jsonEncode(jsonFileContent));
      print("save data");
    } else {
      print("File does not exist!");
      createFile(jsonEncode(map), dir, jsonFileName);
    }
  }
  bool isFileExist() {
    return fileExists;
  }
  Future<dynamic> saveHttpGetMap(String url) async {
    String resp;
    try {
      final response = await http.get(url);
      switch (response.statusCode) {
        case 001:
          resp = response.body;
          print(response.statusCode);
          print("saving your data..." + response.body);
          saveJsonData(response.body);
          break;
        case 200:
          resp = response.body;
          print(response.statusCode);
          print("saving your data..." + response.body);
          saveJsonData(response.body);
          //return response.body;
          break;
        case 400:
          resp = response.body;
          throw BadRequestException(response.body.toString());
          break;
        case 401:
          resp = response.body;
          break;
        case 403:
          resp = response.body;
          throw UnauthorisedException(response.body.toString());
          break;
        case 500:
          resp = response.body;
          break;
        default:
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      }
    } catch (e) {
      print('Error ${e.toString()}');
    }
    final parsed=HttpMap.responseToMap(resp);
    return parsed;
  }
  Future<dynamic> saveHttpPostMap(
      String url, Map<String, dynamic> body) async {
    String resp;
    print(body);
    http.post(url, body: jsonEncode(body)).then((result) {
      switch (result.statusCode) {
        case 200:
          resp = result.body;
          print(result.statusCode);
          print("saving your data..." + result.body);
          saveJsonData(result.body);
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
        final parsed=HttpMap.responseToMap(resp);
    return parsed;
  }
}