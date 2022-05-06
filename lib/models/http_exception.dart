class HttpException implements Exception {
  final String mess;

  HttpException(this.mess);

  @override
  String toString() {
    return mess;
    // return super.toString();  // Instance of HttpException
  }
}
