import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/starting/presentation/widgets/bubble_widgets.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<StartingScreen>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage1()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E0052),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: SizedBox(
              width: 369.22,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Meet the',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w200,
                        height: 1.07,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: Color(0xFFF5EFFC),
                        fontSize: 64,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: 'Mentor AI!',
                      style: TextStyle(
                        color: Color(0xFFB87EFF),
                        fontSize: MediaQuery.of(context).size.width * 0.09,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w900,
                        height: 1.16,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            left: MediaQuery.of(context).size.width * 0.41 - 100,
            child: SizedBox(
              width: 350,
              height: 350,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(top: 75, left: 90, child: smallBubble(4)),
                  Positioned(top: 60, left: 92, child: smallBubble(10)),
                  Positioned(top: 45, left: 100, child: smallBubble(14)),
                  Positioned(top: 10, left: 120, child: bubbleWithText(100)),
                  Positioned(
                    bottom: 20,
                    child: Image.asset(
                      'assets/images/Ropot.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ],
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
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            _animation.value > 0.5 ? "Gooo!" : "Get Started",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: (_animation.value * 20),
                          top: 20,
                          child: Opacity(
                            opacity: 1 - _animation.value,
                            child: Row(
                              children: [
                                Icon(Icons.arrow_forward_ios,
                                    color: Colors.white60, size: 16),
                                Opacity(
                                  opacity: 0.6,
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.white60, size: 16),
                                ),
                                Opacity(
                                  opacity: 0.3,
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.white60, size: 16),
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
                              color: Color(0xFFB87EFF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                _animation.value == 1.0
                                    ? Icons.check
                                    : Icons.arrow_forward_ios,
                                color: Colors.white,
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
