import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../request_models/upload_image_request_model.dart';
import 'auth_service.dart';
import 'exception_handler.dart';

class NetworkHandler{

  //opening a persistent connection
  var client = http.Client();
  var logger = Logger();

  Future<dynamic> get({ required Uri uri, required String jwtToken, required String refreshToken}) async{
    print("#######in get");
    print("#######url: " + uri.toString());

    String newJwtToken = "";
    String newRefreshToken = "";

    var response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization' : jwtToken,
        'RefreshToken' : refreshToken,
      },
    );

    if (response.statusCode == 200) {
      print(response.headers);
      //saving access token
      if(response.headers['authorization'] != null && response.headers['authorization']!.isNotEmpty){
        newJwtToken = response.headers['authorization']!;
        authService.storeAccessTokenData(newJwtToken);
      }

      //saving refresh token
       if(response.headers['refreshtoken'] != null && response.headers['refreshtoken']!.isNotEmpty){
         newRefreshToken = response.headers['refreshtoken']!;
         authService.storeRefreshTokenData(newRefreshToken);
       }

      logger.i(response.statusCode);
      logger.i(response.body);
      return jsonDecode(response.body);
    }
    else {
      logger.d(response.statusCode);
      logger.d(response.body);
      _throwNetworkException(response.statusCode, response.body);
    }
  }

  Future<dynamic> post({required Uri uri, Map<String, dynamic>? body, String? jwtToken, String? refreshToken}) async {
    print("#######in post");
    print("#######url: " + uri.toString());
    print("#######body: " + body.toString());

    String newJwtToken = "";
    String newRefreshToken = "";

    var response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : jwtToken ?? "",
          'RefreshToken' : refreshToken ?? "",
        },
        body: jsonEncode(body));

    if(response.statusCode==200 || response.statusCode==201){

      //saving access token
      if(response.headers['authorization'] != null && response.headers['authorization']!.isNotEmpty){
        newJwtToken = response.headers['authorization']!;
        authService.storeAccessTokenData(newJwtToken);
      }

      //saving refresh token
      if(response.headers['refreshtoken'] != null && response.headers['refreshtoken']!.isNotEmpty){
        newRefreshToken = response.headers['refreshtoken']!;
        authService.storeRefreshTokenData(newRefreshToken);
      }

      logger.i(response.statusCode);
      logger.i(response.body);
      if(response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return "";
      }
    }
    else{
      logger.d(response.statusCode);
      logger.d(response.body);
      _throwNetworkException(response.statusCode, response.body);
    }

  }

  Future<dynamic> put({required Uri uri, required Map<String, dynamic> body, required String jwtToken, required String refreshToken}) async {
    print("#######in put");
    print("#######url: " + uri.toString());
    print("#######body: " + body.toString());

    String newJwtToken = "";
    String newRefreshToken = "";

    var response = await client.put(
      //Uri.parse(url),
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : jwtToken,
          'RefreshToken' : refreshToken,
        },
        body: jsonEncode(body));

    if(response.statusCode==200 || response.statusCode==201){
      //saving access token
      if(response.headers['authorization'] != null && response.headers['authorization']!.isNotEmpty){
        newJwtToken = response.headers['authorization']!;
        authService.storeAccessTokenData(newJwtToken);
      }

      //saving refresh token
      if(response.headers['refreshtoken'] != null && response.headers['refreshtoken']!.isNotEmpty){
        newRefreshToken = response.headers['refreshtoken']!;
        authService.storeRefreshTokenData(newRefreshToken);
      }

      logger.i(response.statusCode);
      logger.i(response.body);
      if(response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return "";
      }
    }
    else{
      logger.d(response.statusCode);
      logger.d(response.body);
      _throwNetworkException(response.statusCode, response.body);
    }

  }

  Future<dynamic> delete({required Uri uri, required String jwtToken, required String refreshToken}) async {
    print("#######in delete");
    print("#######url: " + uri.toString());

    String newJwtToken = "";
    String newRefreshToken = "";

    var response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization' : jwtToken,
          'RefreshToken' : refreshToken,
        });

    if(response.statusCode==200 || response.statusCode==201){
      //saving access token
      if(response.headers['authorization'] != null && response.headers['authorization']!.isNotEmpty){
        newJwtToken = response.headers['authorization']!;
        authService.storeAccessTokenData(newJwtToken);
      }

      //saving refresh token
      if(response.headers['refreshtoken'] != null && response.headers['refreshtoken']!.isNotEmpty){
        newRefreshToken = response.headers['refreshtoken']!;
        authService.storeRefreshTokenData(newRefreshToken);
      }

      logger.i(response.statusCode);
      logger.i(response.body);
      if(response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return "";
      }
    }
    else{
      logger.d(response.statusCode);
      logger.d(response.body);
      _throwNetworkException(response.statusCode, response.body);
    }

  }

  Future<dynamic> patchImage({required Uri uri, required UploadImageRequest imageUploadRequest, required String jwtToken, required String refreshToken}) async {
    //String token = await storage.read(key: "token");
    print("#######in put");
    print("#######url: " + uri.toString());

    String newJwtToken = "";
    String newRefreshToken = "";

    Map<String, String> headers = {
      'Content-Type' : 'multipart/form-data',
      'Authorization' : jwtToken,
      'RefreshToken' : refreshToken,
    };

    var request =  http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    //request.fields['entity_id'] = imageUploadRequest.getEntityId.toString();
    request.files.add(http.MultipartFile.fromBytes('formFile', io.File(imageUploadRequest.getImage.path).readAsBytesSync(),filename: imageUploadRequest.getImage.path));

    var response = await request.send();

    if(response.statusCode==200 || response.statusCode==201){
      //saving access token
      if(response.headers['authorization'] != null && response.headers['authorization']!.isNotEmpty){
        newJwtToken = response.headers['authorization']!;
        authService.storeAccessTokenData(newJwtToken);
      }

      //saving refresh token
      if(response.headers['refreshtoken'] != null && response.headers['refreshtoken']!.isNotEmpty){
        newRefreshToken = response.headers['refreshtoken']!;
        authService.storeRefreshTokenData(newRefreshToken);
      }

      logger.i(response.statusCode);
      logger.i(response.stream.toString());

      return response.stream;

    } else{
      logger.d(response.statusCode);
      logger.d(response.stream.toString());
      _throwNetworkException(response.statusCode, response.stream.toString());
    }
  }

  Future<dynamic> downloadFile({required String url, required Directory directory, required String fileNameToBeSaved, Map<String, dynamic>? queryParameters, required String jwtToken, required String refreshToken}) async {
    print("#######in download");
    print("#######url: " + url);

    bool success = false;
    var dio = Dio();
    dio.options.headers["Authorization"]=jwtToken;
    dio.options.headers["RefreshToken"]=refreshToken;

    String newJwtToken = "";
    String newRefreshToken = "";

      try {
        var response = await dio.download(
            url,
            '${directory!.path}/$fileNameToBeSaved',
            queryParameters: queryParameters
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          //saving access token
          //print(response.headers['refreshtoken']);
          if(response.headers['authorization'] != null && response.headers['authorization']!.isNotEmpty){
            newJwtToken = response.headers['authorization']! as String;
            authService.storeAccessTokenData(newJwtToken);
          }

          //saving refresh token
          if(response.headers['refreshtoken'] != null && response.headers['refreshtoken']!.isNotEmpty){
            newRefreshToken = response.headers['refreshtoken']! as String;
            authService.storeRefreshTokenData(newRefreshToken);
          }

          logger.i(response.statusCode);
          logger.i(response.data);
        }

        if(response.data != null) {
          return jsonDecode(response.data);
        } else {
          return "";
        }

      } on DioException catch (e) {

        logger.d(e.response?.statusCode);
        logger.d(e.response?.data);
        _throwNetworkException(e.response!.statusCode!, e.response!.data!);

      } catch (e, stacktrace) {
        logger.d(stacktrace);
      }
  }

  dynamic _throwNetworkException(int statusCode, String errorMessage) {
    switch (statusCode) {
      case 400: //Bad request
        //throw BadRequestException(jsonDecode(response.body)['message']);
        throw BadRequestException(errorMessage);
      case 401: //Unauthorized
        //throw UnAuthorizedException(jsonDecode(response.body)['message']);
        throw UnAuthorizedException(errorMessage);
      case 403: //Forbidden
        //throw UnAuthorizedException(jsonDecode(response.body)['message']);
        throw UnAuthorizedException(errorMessage);
      case 404: //Resource Not Found
        //throw NotFoundException(jsonDecode(response.body)['message']);
        throw NotFoundException(errorMessage);
      case 440: //Session time out
      //throw NotFoundException(jsonDecode(response.body)['message']);
        throw SessionTimeOutException(errorMessage);
      case 500: //Internal Server Error
        //throw InternalServerErrorException(jsonDecode(response.body)['message']);
        throw InternalServerErrorException(errorMessage);
      default:
        throw FetchDataException('Something went wrong! Response status code: $statusCode');
    }
  }

}