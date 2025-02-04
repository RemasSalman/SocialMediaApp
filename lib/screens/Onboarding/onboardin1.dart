import 'package:flutter/material.dart';

class Onboardin1 extends StatelessWidget {
  const Onboardin1({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(15, 22, 34, 1),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/onboarding1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 258,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'CHAT WITH COWORKERS !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 228,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Join Conversations with your project team ',
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
