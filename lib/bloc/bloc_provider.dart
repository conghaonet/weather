import 'package:flutter/material.dart';

Type _typeOf<T>() => T;

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

  @deprecated
  static List<BlocBase> of(BuildContext context) {
    final type = _typeOf<BlocProvider<BlocBase>>();
    BlocProvider<BlocBase> provider = context.ancestorWidgetOfExactType(type);
    return provider?.blocs;
  }

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
  @override
  void dispose() {
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
