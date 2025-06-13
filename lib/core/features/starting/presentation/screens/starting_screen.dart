import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/sign_up/screens/signup_screen.dart';
import 'package:road_map_mentor/core/features/default_home/screens/default_home_page.dart';
import 'dart:ui';

import 'package:road_map_mentor/core/utils/app_routers.dart';
class StartingScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<StartingScreen> with TickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _arrowController1;
  late AnimationController _arrowController2;
  late AnimationController _arrowController3;

  late Animation<double> _opacity1;
  Animation<double>? _opacity2;
  Animation<double>? _opacity3;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    // Controllers for arrows
    _arrowController1 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _arrowController2 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _arrowController3 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create opacity animations directly
    _opacity1 = Tween<double>(begin: 0, end: 1).animate(_arrowController1);
    _opacity2 = Tween<double>(begin: 0, end: 1).animate(_arrowController2);
    _opacity3 = Tween<double>(begin: 0, end: 1).animate(_arrowController3);

    // Delay repeating (but not initialization)
    Future.delayed(Duration(milliseconds: 100), () {
      _arrowController2.repeat(reverse: true);
      setState(() {}); // to trigger rebuild with _opacity2
    });

    Future.delayed(Duration(milliseconds: 200), () {
      _arrowController3.repeat(reverse: true);
      setState(() {}); // to trigger rebuild with _opacity3
    });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 1), () {
          context.go(AppRouter.home1);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _arrowController1.dispose();
    _arrowController2.dispose();
    _arrowController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
      body: Stack(
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
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
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
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
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
                  color: Color(0xFF40174C),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment(-0.4, 0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Meet the\n',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: MediaQuery.of(context).size.width * 0.09,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w100,
                        height: 1.07,
                      ),
                    ),
                    TextSpan(
                      text: 'Mentor AI!',
                      style: TextStyle(
                        color: Color(0xFF9860E4),
                        fontSize: MediaQuery.of(context).size.width * 0.10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        height: 1.16,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 350,
                height: 350,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(top: 62, left: 96, child: smallBubble(4)),
                    Positioned(top: 45, left: 98, child: smallBubble(10)),
                    Positioned(top: 25, left: 108, child: smallBubble(14)),
                    Positioned(top: -9, left: 130, child: bubbleWithText(100)),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/image.png',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) {
                _controller.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double buttonWidth = MediaQuery.of(context).size.width - 40;
                  return Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white60, width: 2),
                      color: _animation.value == 1.0 ? Color(0xFF9860E4) : Colors.transparent,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            _animation.value > 0.5 ? "Gooooooo!" : "Get Started",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: (_animation.value * 5),
                          top: 22,
                          child: Opacity(
                            opacity: 1 - _animation.value,
                            child: Row(
                              children: [
                                FadeTransition(
                                  opacity: _opacity1,
                                  child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                                ),
                                SizedBox(width: 5),
                                if (_opacity2 != null)
                                  FadeTransition(
                                    opacity: _opacity2!,
                                    child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                                  ),
                                SizedBox(width: 5),
                                if (_opacity3 != null)
                                  FadeTransition(
                                    opacity: _opacity3!,
                                    child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: (_animation.value * (buttonWidth - 60)) + 5,
                          top: 6,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _animation.value == 1.0 ? Colors.white : Color(0xFF9860E4),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                _animation.value == 1.0 ? Icons.check : Icons.arrow_forward_ios,
                                color: _animation.value == 1.0 ? Color(0xFF9860E4) : Colors.white,
                                size: 20,
                              ),
                            ),

                          ),

                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget smallBubble(double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white24,
    ),
  );
}

Widget bubbleWithText(double size) {
  return Container(
    width: 160,
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(30),
    ),
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: 20),
    child: Text(
      "Need our help now?",
      style: TextStyle(
        fontSize: 18,
        color: Colors.white60,
        height: 1.0,
      ),
    ),
  );
}


