


class UnauthorisedException implements Exception {
  final String? message;

  UnauthorisedException({required this.message});
}

class NoAccountForChosenCurrencyException implements Exception{
  final String? message;
  NoAccountForChosenCurrencyException({required this.message});
}

class AlreadyHaveVirtualCardException implements Exception {
  final String? message;
  AlreadyHaveVirtualCardException({required this.message});
}

class UnEnableDeviceException implements Exception {
  final String? message;
  UnEnableDeviceException({required this.message});
}