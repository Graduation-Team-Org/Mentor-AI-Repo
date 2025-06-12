import 'package:flutter/material.dart';

class KeepWidgetAlive extends StatefulWidget {
  const KeepWidgetAlive({super.key, required this.aliveGivenWidget});

  final Widget aliveGivenWidget;

  @override
  State<KeepWidgetAlive> createState() => _KeepWidgetAliveState();
}

class _KeepWidgetAliveState extends State<KeepWidgetAlive> with AutomaticKeepAliveClientMixin<KeepWidgetAlive> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.aliveGivenWidget;
  }
  
  @override
  bool get wantKeepAlive => true;
}
