class MyBaseException implements Exception {
  final String message;
  const MyBaseException(this.message);
  String toString({String tag}) {
    String report = tag;
    if (message != null && "" != message) {
      report = "$report: $message";
    }
    return report;
  }
}

class MyNetworkException extends MyBaseException {
  const MyNetworkException(String message): super(message);
  @override
  String toString({String tag="MyNetworkException"}) {
    return this.toString(tag: tag);
  }
}

class MyCityConvertException extends MyBaseException {
  const MyCityConvertException(String message): super(message);
  @override
  String toString({String tag="MyCityConvertException"}) {
    return this.toString(tag: tag);
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
