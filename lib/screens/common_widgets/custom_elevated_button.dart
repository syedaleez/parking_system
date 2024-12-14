import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed; // Action to perform when the button is pressed
  final String text; // Button text
  final bool isLoading; // Indicates if the button is in a loading state
  final Color backgroundColor; // Button background color
  final Color textColor; // Button text color
  final double fontSize; // Font size for the text
  final Color loadingIndicatorColor; // Loading spinner color
  final OutlinedBorder? shape; // Customizable button shape

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false, // Default to not loading
    this.backgroundColor = Colors.blueAccent, // Default background color
    this.textColor = Colors.white, // Default text color
    this.fontSize = 18.0, // Default font size
    this.loadingIndicatorColor = Colors.white, // Default loading spinner color
    this.shape, // Allow customization of the button's shape
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // Disable button when loading
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // Full-width button
        backgroundColor: backgroundColor,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15), // Default rounded corners
            ),
      ),
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: loadingIndicatorColor,
                strokeWidth: 2.5, // Adjust spinner thickness
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            ),
    );
  }
}
