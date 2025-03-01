
import 'package:cipherly/screens/mainscreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assest/blue-2970618_1920.jpg', // Correct path to your image
            fit: BoxFit.cover,
          ),
          // Semi-transparent overlay for text readability
          Container(
            color: Colors.black.withOpacity(0.1), // Adjust transparency as needed
          ),
          // Column for content alignment
          Column(
            children: [
              // Spacer to push content to the center
              const Spacer(),
              // Centered texts
              Column(
                children: [
                  Text(
                    "Cipherly",
                    style: TextStyle(
                      fontSize: screenWidth * 0.19, // Responsive text size
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Welcome to Cipherly App 🚀",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Responsive text size
                      color: const Color.fromARGB(255, 0, 22, 94),
                    ),
                  ),
                ],
              ),
              // Spacer to separate text from bottom row
              const Spacer(),
              // Bottom row with text and button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, // Responsive horizontal padding
                  vertical: screenHeight * 0.03, // Responsive vertical padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text with semi-transparent background
                    Container(
                      width: screenWidth * 0.7, // Responsive width
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05, // Responsive horizontal padding
                        vertical: screenHeight * 0.02, // Responsive vertical padding
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8), // Semi-transparent background
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Convert Your text into a secret code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Floating Action Button
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Mainscreen(),
                          ),
                        );
                      },
                      backgroundColor: Colors.black.withOpacity(0.8),
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
