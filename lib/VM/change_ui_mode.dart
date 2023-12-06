import 'package:flutter/material.dart';

class ChangeUIMode extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const ChangeUIMode({super.key, required this.onChangeTheme});      

  @override
  State<ChangeUIMode> createState() => _ChangeUIModeState();
}

class _ChangeUIModeState extends State<ChangeUIMode> {
  late bool isLightMode;
  
  @override
  void initState() {
    super.initState();
    isLightMode = true;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}