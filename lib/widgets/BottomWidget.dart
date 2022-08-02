import 'package:flutter/material.dart';
import 'package:manek_tech_practicle/utils/AppColors.dart';
import 'package:manek_tech_practicle/utils/Styles.dart';

// ignore: must_be_immutable
class BottonWidget extends StatefulWidget {
  String title;
  // ignore: use_key_in_widget_constructors
  BottonWidget({required this.title});

  @override
  // ignore: no_logic_in_create_state
  State<BottonWidget> createState() => _BottonWidgetState(title);
}

class _BottonWidgetState extends State<BottonWidget> {
  String title;
  _BottonWidgetState(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: AppColors.primaryColor),
      alignment: Alignment.center,
      child: Text(title,
          style:appbarTitleStyle),
    );
  }
}