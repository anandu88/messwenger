import 'package:flutter/material.dart';

class Errorscreen extends StatelessWidget {
 final String error;
  const Errorscreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}