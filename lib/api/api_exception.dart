// ignore_for_file: prefer_typing_uninitialized_variables

class ApiException implements Exception {
  final prefix;
  final message;
  ApiException([this.prefix, this.message]);
  @override
  String toString() {
    return '$prefix $message';
  }
}

// throw exception when failed to communication with server
class FetchDataException extends ApiException {
  FetchDataException([String? message]) : super('Error During Communication:', message);
}

// throw exception when called invalid request
class BadRequestException extends ApiException {
  BadRequestException([message]) : super('Invalid Request:', message);
}

// throw exception when pass unauthorised user token
class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super('Unauthorised:', message);
}

// throw exception when invalid input from userdata
class InvalidInputException extends ApiException {
  InvalidInputException([String? message]) : super('Invalid Input:', message);
}
