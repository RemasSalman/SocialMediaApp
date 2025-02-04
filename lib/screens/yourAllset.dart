import 'package:flutter/material.dart';
import 'package:p8/screens/tabs.dart';
import 'package:lottie/lottie.dart';
import 'package:p8/widgets/customscaff.dart';

class Yourallset extends StatefulWidget {
  const Yourallset({super.key});

  @override
  State<Yourallset> createState() => _YourallsetState();
}

class _YourallsetState extends State<Yourallset> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () { // Adjust the duration to slow down the animation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const TabScreen(), // Replace with your next screen
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
        children: [
          Align(
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/animation/sl7Wj1DEYJ.json',
              height: 200,
            ),
          ),
          SizedBox(height: 20), // Add spacing between the animation and text
          Text(
            "YOU'RE ALL SET!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}