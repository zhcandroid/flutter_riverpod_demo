class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => message;

  bool get isUnauthorized => statusCode == 401;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
}