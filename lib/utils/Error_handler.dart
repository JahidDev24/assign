import 'package:dio/dio.dart';

class ServerError implements Exception {
  int? _errorCode = 200;
  String _errorMessage = "";

  ServerError.withError({required DioException? error}) {
    _handleError(error!);
  }

  int? getErrorCode() {
    return _errorCode;
  }

  String getErrorMessage() {
    return _errorMessage;
  }

  void _handleError(DioException error) {
    _errorCode = error.response?.statusCode ?? 0;

    switch (error.type) {
      case DioExceptionType.cancel:
        _errorMessage = "Request was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        _errorMessage =
            "Connection timeout. Please check your internet connection.";
        break;
      case DioExceptionType.unknown:
        _errorMessage = "An unknown error occurred. Please try again.";
        break;
      case DioExceptionType.receiveTimeout:
        _errorMessage = "Receive timeout in connection. Please try again.";
        break;
      case DioExceptionType.badResponse:
        if (error.response != null) {
          switch (error.response!.statusCode) {
            case 400:
              _errorMessage =
                  "Bad request. The server could not understand the request.";
              break;
            case 401:
              _errorMessage =
                  "Unauthorized. Please check your authentication credentials.";
              break;
            case 403:
              _errorMessage =
                  "Forbidden. You do not have permission to access this resource.";
              break;
            case 404:
              _errorMessage =
                  "Not found. The requested resource could not be found.";
              break;
            case 408:
              _errorMessage =
                  "Request timeout. The request took too long to complete.";
              break;
            case 429:
              _errorMessage = "Too many requests. You have hit the rate limit.";
              break;
            case 500:
              _errorMessage = "Internal server error. Please try again later.";
              break;
            case 502:
              _errorMessage =
                  "Bad gateway. The server received an invalid response from the upstream server.";
              break;
            case 503:
              _errorMessage =
                  "Service unavailable. The server is currently unable to handle the request.";
              break;
            case 504:
              _errorMessage =
                  "Gateway timeout. The server took too long to respond.";
              break;
            default:
              _errorMessage =
                  "An error occurred: ${error.response!.statusMessage}";
          }
        } else {
          _errorMessage = "An error occurred: ${error.message}";
        }
        break;
      case DioExceptionType.sendTimeout:
        _errorMessage = "Send timeout. The request took too long to send.";
        break;
      case DioExceptionType.badCertificate:
        _errorMessage =
            "Bad certificate. The server's certificate could not be validated.";
        break;
      case DioExceptionType.connectionError:
        _errorMessage =
            "Connection error. Please check your internet connection.";
        break;
      default:
        _errorMessage = "An unexpected error occurred.";
    }
  }
}
