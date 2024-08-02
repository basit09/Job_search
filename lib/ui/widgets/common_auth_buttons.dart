import 'package:flutter/material.dart';

class CommonAuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool? isApplied;

  const CommonAuthButton({
    super.key,
    required this.onTap,
    required this.text,
     this.isApplied,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (isApplied ?? false) ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration:  ShapeDecoration(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              color: (isApplied ?? false) ? Colors.grey: Colors.blue),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
