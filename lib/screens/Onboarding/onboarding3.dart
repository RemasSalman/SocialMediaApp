import 'package:flutter/material.dart';

class Onboardin3 extends StatelessWidget {
  const Onboardin3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(15, 22, 34, 1),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/onboarding3.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 240, // Adjust the bottom position as needed
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'CONNECT WITH TEAMLINK !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 210, // Adjust the bottom position as needed
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Stay Engaged and Expand Your Connections',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}