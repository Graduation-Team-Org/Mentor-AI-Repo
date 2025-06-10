import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;

  Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Sent timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioExceptionType.badCertificate:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioException.response!.statusCode!, dioException.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure('Opps!, Request to ApiServer was canceled');

      case DioExceptionType.connectionError:
        return ServerFailure(
            'Please, Check Your Internet Connection.');

      case DioExceptionType.unknown:
        if (dioException.message!.contains('SoketExeption')) {
          return ServerFailure('No Internet Connection');
        }
        return ServerFailure('Unexpected Error, please try again later!');
      }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 400) {
      return ServerFailure('Request Not Found, please try again later!');
    } else if (statusCode == 500) {
      return ServerFailure('Internal server error, please try again later!');
    } else {
      return ServerFailure('Opps there was an error, please try again later!');
    }
  }
}
