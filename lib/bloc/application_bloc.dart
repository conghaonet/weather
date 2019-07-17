import 'dart:async';
import 'dart:ui';

import '../translations.dart';
import 'bloc_provider.dart';

class ApplicationBloc extends BlocBase {
  final _applicationController = StreamController<Locale>.broadcast();
  StreamSink<Locale> get _applicationSink => _applicationController.sink;
  Stream<Locale> get applicationStream => _applicationController.stream;
  SpecificLocalizationDelegate localeOverrideDelegate = SpecificLocalizationDelegate(null);

  onChangeLocale(Locale locale) {
    localeOverrideDelegate = SpecificLocalizationDelegate(locale);
    _applicationSink.add(locale);
  }
  @override
  void dispose() {
    _applicationController.close();
  }

}