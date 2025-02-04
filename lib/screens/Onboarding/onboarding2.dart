import 'package:flutter/material.dart';

class Onboardin2 extends StatelessWidget {
  const Onboardin2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(15, 22, 34, 1),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/on2.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 235, // Adjust the bottom position as needed
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "SHEAR YOU'R SUCCESS !",
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
                "Celebrate you'r achievements through every post",
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