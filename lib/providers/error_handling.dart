class ErrorHandling implements Exception {
  String errorMessage;
  ErrorHandling(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}
