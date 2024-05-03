// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';
import 'api_exception.dart';

http.Client client = http.Client();

class APIManager {
  bool isNoInternetMessageDisplayed = false;
  bool isSessionExpiredMessageDisplayed = false;

  // GET
  Future<dynamic> getAPICall({required String url, bool isLoaderShow = true, int timeOut = 60}) async {
    var responseJson;
    // Check internet is on or not
    if (isInternetAvailable.value == true) {
      showLoaderIfNeeded(isLoaderShow);
      var headers = createHeaders();
      // Send an HTTP request
      Future<http.Response> request = client.get(Uri.parse(url), headers: headers).timeout(
        Duration(seconds: timeOut),
        onTimeout: () {
          return http.Response('Request timed out', 408);
        },
      );

      // Wait for the request to complete and print the response
      try {
        http.Response response = await request;
        log('\x1B[90m<--------------------------- [GET API] --------------------------->\x1B[0m');
        log('\x1B[94m[Url] => \x1B[95m$url\x1B[0m');
        log('\x1B[94m[Headers] => \x1B[95m$headers\x1B[0m');
        log('\x1B[94m[Response (${response.statusCode})] => \x1B[96m${response.statusCode == 200 ? response.body : response.reasonPhrase}\x1B[0m');
        log('\x1B[90m<----------------------------------------------------------------->\x1B[0m');
        responseJson = _response(response);
      } on SocketException catch (error) {
        handleSocketException(error);
      } on TimeoutException {
        handleTimeoutException();
      } catch (error, stackTrace) {
        handleGenericError(error, stackTrace);
      } finally {
        hideLoaderIfNeeded(isLoaderShow);
      }
    } else {
      handleNoInternet();
    }
    return responseJson;
  }

  // POST
  Future<dynamic> postAPICall({required String url, required var params, bool isLoaderShow = true, int timeOut = 120}) async {
    var responseJson;

    // Check internet is on or not
    if (isInternetAvailable.value == true) {
      showLoaderIfNeeded(isLoaderShow);
      var headers = createHeaders();
      String body = json.encode(params);
      // Send an HTTP request
      Future<http.Response> request = client.post(Uri.parse(url), headers: headers, body: body).timeout(
        Duration(seconds: timeOut),
        onTimeout: () {
          return http.Response('Request timed out', 408);
        },
      );

      try {
        http.Response response = await request;
        log('\x1B[90m<--------------------------- [POST API] --------------------------->\x1B[0m');
        log('\x1B[94m[Url] => \x1B[95m$url\x1B[0m');
        log('\x1B[94m[Headers] => \x1B[95m$headers\x1B[0m');
        log('\x1B[94m[Parameters] => \x1B[95m$body\x1B[0m');
        log('\x1B[94m[Response (${response.statusCode})] => \x1B[96m${response.statusCode == 200 ? response.body : response.reasonPhrase}\x1B[0m');
        log('\x1B[90m<----------------------------------------------------------------->\x1B[0m');
        responseJson = _response(response);
      } on SocketException catch (error) {
        handleSocketException(error);
      } on TimeoutException catch (_) {
        handleTimeoutException();
      } catch (error, stackTrace) {
        handleGenericError(error, stackTrace);
      } finally {
        hideLoaderIfNeeded(isLoaderShow);
      }
    } else {
      handleNoInternet();
    }
    return responseJson;
  }

  // PUT
  Future<dynamic> putAPICall({required String url, required var params, bool isLoaderShow = true, int timeOut = 60}) async {
    var responseJson;
    try {
      // Check internet is on or not
      if (isInternetAvailable.value == true) {
        showLoaderIfNeeded(isLoaderShow);
        var headers = createHeaders();
        String body = json.encode(params);
        await client.put(Uri.parse(url), headers: headers, body: body).timeout(Duration(seconds: timeOut)).then((response) {
          log('\x1B[90m<--------------------------- [PUT API] --------------------------->\x1B[0m');
          log('\x1B[94m[Url] => \x1B[95m$url\x1B[0m');
          log('\x1B[94m[Headers] => \x1B[95m$headers\x1B[0m');
          log('\x1B[94m[Parameters] => \x1B[95m$body\x1B[0m');
          log('\x1B[94m[Response (${response.statusCode})] => \x1B[96m${response.statusCode == 200 ? response.body : response.reasonPhrase}\x1B[0m');
          log('\x1B[90m<----------------------------------------------------------------->\x1B[0m');
          responseJson = _response(response);
        });
      } else {
        handleNoInternet();
      }
    } on SocketException catch (error) {
      handleSocketException(error);
    } on TimeoutException catch (_) {
      handleTimeoutException();
    } catch (error, stackTrace) {
      handleGenericError(error, stackTrace);
    } finally {
      hideLoaderIfNeeded(isLoaderShow);
    }
    return responseJson;
  }

  // MULTIPART
  Future<dynamic> multipartAPICall({required String url, required Map<String, dynamic> params, required String fileKey, required File file, bool isLoaderShow = true, int timeOut = 60}) async {
    var responseJson;
    try {
      // Check internet is on or not
      if (isInternetAvailable.value == true) {
        showLoaderIfNeeded(isLoaderShow);
        var headers = createHeaders();
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(headers);
        // Add other parameters
        params.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        // Add file to request
        request.files.add(
          await http.MultipartFile.fromPath(
            fileKey,
            file.path,
            filename: file.path.split('/').last,
          ),
        );
        http.StreamedResponse response = await request.send();
        Uint8List responseData = await response.stream.toBytes();
        String responseString = utf8.decode(responseData);
        log('\x1B[90m<--------------------------- [MULTIPART API] --------------------------->\x1B[0m');
        log('\x1B[94m[Url] => \x1B[95m$url\x1B[0m');
        log('\x1B[94m[Headers] => \x1B[95m$headers\x1B[0m');
        log('\x1B[94m[Parameters Fields] => \x1B[95m${request.fields}\x1B[0m');
        log('\x1B[94m[Parameters Files] => \x1B[95m{"FieldName": ${request.files.first.field}, "FileName": ${request.files.first.filename}, "FileLength": ${request.files.first.length}, "ContentType": ${request.files.first.contentType}}\x1B[0m');
        log('\x1B[94m[Response (${response.statusCode})] => \x1B[96m${response.statusCode == 200 ? responseString : response.reasonPhrase}\x1B[0m');
        log('\x1B[90m<----------------------------------------------------------------->\x1B[0m');
        responseJson = _response(http.Response(responseString, response.statusCode));
      }
    } on SocketException catch (error) {
      handleSocketException(error);
    } on TimeoutException catch (_) {
      handleTimeoutException();
    } catch (error, stackTrace) {
      handleGenericError(error, stackTrace);
    } finally {
      hideLoaderIfNeeded(isLoaderShow);
    }
    return responseJson;
  }

  void showLoaderIfNeeded(bool isLoaderShow) {
    if (isLoaderShow) {
      showProgressIndicator();
    }
  }

  void hideLoaderIfNeeded(bool isLoaderShow) {
    if (isLoaderShow) {
      dismissProgressIndicator();
    }
  }

  Map<String, String> createHeaders() {
    if (isTokenValid.value == true) {
      return GetStorage().read(loginDataKey) != null && getAuthToken().isNotEmpty
          ? {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${getAuthToken()}',
            }
          : {
              'Content-Type': 'application/json',
            };
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }

  void handleNoInternet() {
    if (isNoInternetMessageDisplayed == false) {
      errorSnackBar(message: noInternetMsg);
      isNoInternetMessageDisplayed = true;
    }
  }

  void handleSessionExpired() {
    if (isSessionExpiredMessageDisplayed == false) {
      errorSnackBar(message: 'Your session has expired!');
      isSessionExpiredMessageDisplayed = true;
    }
  }

  void handleSocketException(SocketException error) {
    log('\x1B[91m[Handle Socket Exception] => $error\x1B[0m');
    throw FetchDataException(error.toString());
  }

  void handleTimeoutException() {
    // errorSnackBar(message: apiTimeOutMsg);
    throw FetchDataException(apiTimeOutMsg);
  }

  void handleGenericError(error, StackTrace stackTrace) {
    if (error.toString().contains('Connection closed while receiving data')) {
      errorSnackBar(message: 'An error occured while communication with server');
    } else if (error.toString().contains('Connection closed before full header was received')) {
      log('\x1B[91m[Handle Generic Error] => Request Canceled\x1B[0m');
    }
    throw FetchDataException('Server Error');
  }

  dynamic _response(http.Response response) async {
    switch (response.statusCode) {
      // Successfully get api response
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 202:
        var responseJson = json.decode(response.body);
        return responseJson;
      // No content
      case 204:
        throw BadRequestException(response.reasonPhrase);
      // Bad request need to check url
      case 400:
        log('\x1B[91m[400-Bad Request] => ${response.body}\x1B[0m');
        throw BadRequestException(response.body);
      // Unauthorized
      case 401:
        errorSnackBar(message: response.body);
        throw BadRequestException(response.body);
      // Authorisation token invalid
      case 403:
        errorSnackBar(message: response.body);
        throw UnauthorisedException(response.body);
      // Error occured while communication with server
      case 500:
      default:
        errorSnackBar(message: 'An error occured while communication to server with status code: ${response.statusCode}');
        throw FetchDataException(
          'An error occured while communication to server with status code: ${response.statusCode}',
        );
    }
  }
}

cancelOngoingRequest() {
  client.close();
  client = http.Client();
}
