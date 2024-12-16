import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.green, // Default background color
    Color textColor = Colors.white, // Default text color
    IconData? icon,
    Color iconColor = Colors.white, // Default icon color
    Duration duration = const Duration(seconds: 2), // Default duration
    OutlinedBorder? shape, // Customizable shape
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Default shape
          ),
      duration: duration,
      margin: const EdgeInsets.all(15),
      elevation: 6,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
