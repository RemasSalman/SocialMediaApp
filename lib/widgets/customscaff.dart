import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(15, 22, 34, 1),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroun2.png'),
                fit: BoxFit.cover,
                opacity: 0.4,
              ),
            ),
          ),

          // Logo
          Column(
            children: [
              const SizedBox(height: 60),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80, // Adjust size
                ),
              ),
            ],
          ),

          // Fade-in Content
          SafeArea(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500), // Adjust fade speed
              curve: Curves.easeInOut,
              child: child!,
            ),
          ),
        ],
      ),
    );
  }
}

// Function to apply Fade Transition when navigating
Route createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
