import 'package:flutter/material.dart';

Type _typeOf<T>() => T;

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final List<T> blocs;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.blocs,
  }) : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static List<T> of<T extends BlocBase>(BuildContext context) {
//    final type = _typeOf<_BlocProviderInherited<T>>();
//    _BlocProviderInherited<T> provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider?.blocs;
  }
  static K first<T extends BlocBase, K extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    if(provider == null) {
      return null;
    } else {
      return provider.blocs.firstWhere((bloc) => bloc is K) as K;
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
    return _BlocProviderInherited<T>(
      blocs: widget.blocs,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T extends BlocBase> extends InheritedWidget {
  final List<T> blocs;
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.blocs,
  }): super(key: key, child: child);

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;

}
