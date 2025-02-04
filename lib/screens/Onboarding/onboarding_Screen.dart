import 'package:flutter/material.dart';
import 'package:p8/screens/Onboarding/onboardin1.dart';
import 'package:p8/screens/Onboarding/onboarding2.dart';
import 'package:p8/screens/Onboarding/onboarding3.dart';
import 'package:p8/screens/auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OnboardingScreen();
  }
}

class _OnboardingScreen extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  bool lastPage = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {});
    });

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    // Slide animation (moves up)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 7),
      end: Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                lastPage = (index == 2);
              });
            },
            children: [
              Onboardin1(),
              Onboardin2(),
              Onboardin3(),
            ],
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: 140),
                SlideTransition(
                  position: _slideAnimation,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 70,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _pageController.jumpToPage(3);
                  },
                  child: const Text(
                    '        Skip',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const WormEffect(
                    dotHeight: 6,
                    dotWidth: 12,
                    spacing: 15,
                    dotColor:Color.fromARGB(144, 26, 48, 86) ,
                    activeDotColor: Color.fromARGB(255, 242, 246, 250),
                  ),
                ),
                lastPage
                    ? FadeTransition(
                        opacity: _animationController,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(_createFadeRoute());
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            fixedSize: Size(80, 0),
                            backgroundColor:
                                const Color.fromARGB(148, 45, 82, 133),
                          ),
                          child: const Text(
                            'Join',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: const Icon(Icons.arrow_right_alt,
                            color: Colors.white),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to create fade transition for navigation
  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AuthenticationScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 700),
    );
  }
}
