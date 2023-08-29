import 'dart:async';
import 'dart:io';

class ExceptionHandlers {
  getExceptionString(error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your connection and try again.';
    } else if (error is HttpException) {
      return 'HTTP error occurred.';
    } else if (error is FormatException) {
      return 'Invalid data format.';
    } else if (error is TimeoutException) {
      return 'The operation timed out.';
    } else if (error is BadRequestException) {
      //return 'Server could not process the request. Please contact Administrator.';
      return error.message.toString();
    } else if (error is UnAuthorizedException) {
      return 'User is not authorized.';
    } else if (error is SessionTimeOutException) {
      return 'Session has expired. Please sign in again.';
    } else if (error is NotFoundException) {
      return error.message.toString().isNotEmpty ? error.message.toString() : "We couldn't find the information you are looking for.";
    } else if (error is FetchDataException) {
      return error.message.toString();
    } else if (error is InternalServerErrorException) {
      return 'The server has encountered an internal error. We are working to fix it.';
    } else {
      return 'Unknown error occurred. Please contact Administrator.';
    }
  }
}

class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad request', url);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, 'Unable to process the request', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
      : super(message, 'Api not responding', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'Unauthorized access', url);
}

class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
      : super(message, 'Page not found', url);
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message, String? url])
      : super(message, 'Internal Server Error', url);
}

class SessionTimeOutException extends AppException {
  SessionTimeOutException([String? message, String? url])
      : super(message, 'Session Time-out', url);
}