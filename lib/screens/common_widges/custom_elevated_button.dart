import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed; // Action to perform when the button is pressed
  final String text; // Button text
  final bool isLoading; // Indicates if the button is in a loading state
  final Color backgroundColor; // Button background color
  final double fontSize; // Font size for the text

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false, // Default to not loading
    this.backgroundColor = Colors.blueAccent, // Default background color
    this.fontSize = 18.0, // Default font size
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Disable button when loading
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // Full-width button
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5, // Adjust spinner thickness
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
              ),
            ),
    );
  }
}
