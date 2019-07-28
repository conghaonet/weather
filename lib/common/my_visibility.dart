import 'package:flutter/widgets.dart';

enum MyVisibilityFlag {
  VISIBLE, INVISIBLE, GONE,
}

class MyVisibility extends StatelessWidget {
  final Widget child;
  final MyVisibilityFlag flag;

  const MyVisibility({
    Key key,
    @required this.flag,
    @required this.child
  }) : assert(child != null),
       assert(flag != null),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(flag) {
      case MyVisibilityFlag.INVISIBLE:
        return Opacity(
          opacity: 0.0,
          child: IgnorePointer(
            ignoring: true,
            child: child,
          ),
        );
      case MyVisibilityFlag.GONE:
        return Offstage(
          offstage: true,
          child: child,
        );
      case MyVisibilityFlag.VISIBLE:
      default:
        return child;
    }
  }

}
