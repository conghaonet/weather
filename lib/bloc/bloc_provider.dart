import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

Type _typeOf<K>() => K;

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final List<BlocBase> blocs;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.blocs,
  }) : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  /// _Deprecated: Use[first] instead._
  @deprecated
  static List<BlocBase> of(BuildContext context) {
    final type = _typeOf<BlocProvider<BlocBase>>();
    BlocProvider<BlocBase> provider = context.ancestorWidgetOfExactType(type);
    return provider?.blocs;
  }

  /// 供外部调用
  static T first<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<BlocBase>>();
    BlocProvider<BlocBase> provider = context.ancestorWidgetOfExactType(type);
    if(provider == null) {
      return null;
    } else {
      return provider.blocs.firstWhere((bloc) => bloc is T) as T;
    }
  }
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  Logger _log = Logger('_BlocProviderState');
  @override
  void dispose() {
    if(widget.blocs != null) {
      for(dynamic bloc in widget.blocs){
        _log.severe("dispose bloc type is "+bloc.runtimeType.toString());
      }
    }
    widget.blocs.map((bloc) {
      bloc.dispose();
    });
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
