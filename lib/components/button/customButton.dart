import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    required this.backgroundColor,
    required this.onPressed,
  }) : super(key: key);

  final Widget title;
  final Color backgroundColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor.withOpacity(0.7),
      ),
      onPressed: onPressed,
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15,
          ),
          child: title),
    );
  }
}
