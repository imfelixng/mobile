import 'package:flutter/widgets.dart';

import 'package:tipid/utils/api.dart';

class TipidApiProvider extends StatefulWidget {
  const TipidApiProvider({Key key, this.api, this.child}) : super(key: key);

  final TipidApi api;
  final Widget child;

  static TipidApi of(BuildContext context) {
    final InheritedTipidApiProvider inheritedTipidApiProvider =
        InheritedTipidApiProvider.of(context);

    return inheritedTipidApiProvider.api;
  }

  @override
  TipidApiProviderState createState() {
    return TipidApiProviderState();
  }
}

class TipidApiProviderState extends State<TipidApiProvider> {
  @override
  Widget build(BuildContext context) {
    return InheritedTipidApiProvider(
      api: widget.api,
      child: widget.child,
    );
  }
}

class InheritedTipidApiProvider extends InheritedWidget {
  const InheritedTipidApiProvider({
    this.api,
    Widget child,
  }) : super(child: child);

  factory InheritedTipidApiProvider.of(BuildContext context) =>
      // ignore: avoid_as
      context.inheritFromWidgetOfExactType(InheritedTipidApiProvider)
          as InheritedTipidApiProvider;

  final TipidApi api;

  @override
  bool updateShouldNotify(InheritedTipidApiProvider oldWidget) => false;
}
