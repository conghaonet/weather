class MyBaseException implements Exception {
  final String message;
  const MyBaseException(this.message);

  @override
  String toString() {
    String report = 'MyBaseException';
    if (message != null && "" != message) {
      report = "$report: $message";
    }
    return report;
  }
}

class MyNetworkException extends MyBaseException {
  const MyNetworkException(String message): super(message);
  @override
  String toString() {
    String report = 'MyNetworkException';
    if (this.message != null && "" != message) {
      report = "$report: $message";
    }
    return report;
  }
}

class MyCityConvertException extends MyBaseException {
  const MyCityConvertException(String message): super(message);
  @override
  String toString() {
    String report = 'MyCityConvertException';
    if (this.message != null && "" != message) {
      report = "$report: $message";
    }
    return report;
  }
}
/*
class MyCityConvertException implements Exception {
  final String message;
  const MyCityConvertException(this.message);
  String toString() {
    String report = "MyCityConvertException";
    if (message != null && "" != message) {
      report = "$report: $message";
    }
    return report;
  }
}*/
