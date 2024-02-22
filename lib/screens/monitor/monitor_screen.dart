import 'package:flutter/material.dart';
import 'package:asocombeima/screens/monitor/components/body.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Body(name: name);
  }
}
