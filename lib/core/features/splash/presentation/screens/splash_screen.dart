import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/starting/presentation/screens/starting_screen.dart';
import 'dart:ui';

import 'package:road_map_mentor/core/utils/app_routers.dart';

class SpScreen extends StatefulWidget {
  const SpScreen({super.key});

  @override
  SpScreenState createState() => SpScreenState();
}

class SpScreenState extends State<SpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _shadowFadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoAnimation = Tween<double>(begin: 100, end: -50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _shadowFadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Interval(0.4, 0.6, curve: Curves.easeOut)),
    );

    _slideAnimation = Tween<double>(begin: 0, end: -100).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Interval(0.5, 0.8, curve: Curves.easeInOut)),
    );

    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.7, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward().then((_) {
      Future.delayed(Duration(milliseconds: 600), () {
        if (mounted) {
          context.go(AppRouter.startingScreen);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 300,
                        left: 60,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF352250),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -30,
                        right: -70,
                        child: ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF9860E4),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: 200,
                        child: ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF9860E4),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF40174C)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight / 2 + 80,
                  child: Opacity(
                    opacity: _shadowFadeAnimation.value,
                    child: ClipOval(
                      child: Container(
                        width: 250,
                        height: 100,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight / 2 + _logoAnimation.value,
                  child: Transform.translate(
                    offset: Offset(_slideAnimation.value, 0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight / 2 - 23,
                  left: screenWidth / 2 - 70,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Text(
                      'MENTOR AI',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF5EFFC),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
