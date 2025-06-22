import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:road_map_mentor/core/features/sign_up/screens/signup_screen.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _centerX = 0;
  final List<Widget> _pages = [];
  final List<GlobalKey> _iconKeys = List.generate(3, (_) => GlobalKey());
  late AnimationController _controller;
  late Animation<Offset> _textOffset;
  late Animation<Offset> _imageOffset;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCurvePosition());


    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );


    _textOffset = Tween<Offset>(
      begin: Offset(-3.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _imageOffset = Tween<Offset>(
      begin: Offset(3.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    _pages.add(_buildHomePage2Content());
    _pages.add(InfoPage());
    _pages.add(ReviewsPage());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildNavIcon({
    required String iconPath,
    required String selectedIconPath,
    required int index, }) {
    final bool isSelected = _currentIndex == index;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: isSelected
          ? BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      )
          : null,
      child: SvgPicture.asset(
        isSelected ? selectedIconPath : iconPath,
        height: 24,
        width: 24,
      ),
    );
  }

  void _updateCurvePosition() {
    final keyContext = _iconKeys[_currentIndex].currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;
      setState(() {
        _centerX = position.dx + size.width / 2;
      });
    }
  }

  Widget _buildHomePage2Content() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildHeader(),
          Expanded(child: _buildServicesList(context)),
        ],
      ),
    );



  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _textOffset,
                child: FadeTransition(
                  opacity: _controller,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(
                            color: Color(0xFFF5EFFC),
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.17,
                          ),
                        ),
                        TextSpan(
                          text: 'Mentor AI ',
                          style: TextStyle(
                            color: Color(0xFF9860E4),
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 3),
              SlideTransition(
                position: _imageOffset,
                child: FadeTransition(
                  opacity: _controller,
                  child: Image.asset(
                    'assets/images/image.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          FadeTransition(
            opacity: _controller,
            child: const Text(
              "Meet our expert AI mentors to gain valuable knowledge and experience.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 78),

      children: [
        _buildServiceCard(context, "Roadmap", "Talk to Steve to find out which roadmap to follow for your desired track.", "assets/images/home1.png", "assets/images/Roadmap.png"),
        _buildServiceCard(context, "Chat With Document", "Talk to Serena to discuss your document in detail and get valuable insights.", "assets/images/home2.png", "assets/images/Chat.png"),
        _buildServiceCard(context, "CV Analysis", "Talk to Marcus to review your CV and find ways to make it stronger.", "assets/images/home3.png", "assets/images/CV.png"),
        _buildServiceCard(context, "Interview", "Talk to David to prepare for your next big interview with confidence and expert guidance.", "assets/images/home4.png", "assets/images/Interview.png"),
        _buildServiceCard(context, "Build CV", "Helping you create a CV tailored for the job market by guiding you on what to include", null, "assets/images/BuildCV.png"),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String description, String? imagePath, String backgroundImagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(description, style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _navigateToService(context, title),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Color(0xFF510887),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath, width: 120, height: 120, fit: BoxFit.cover),
            ),
        ],
      ),
    );
  }

  void _navigateToService(BuildContext context, String service) {
    _showSignUpDialog(context);
  }

  void _showSignUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color(0xFF9860E4), width: 2),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Please sign up first to access our services.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4C1D95),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.7),
                      border: Border.all(color: Color(0xFF9860E4), width: 1.5),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 14),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          // الصفحات


          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavWithDynamicCurve(
              selectedIndex: _currentIndex,
              centerX: _centerX,
              iconKeys: _iconKeys,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _updateCurvePosition();
                });
              },
            ),
          ),
        ],
      ),


    );
  }
}


class BottomNavWithDynamicCurve extends StatelessWidget {
  final int selectedIndex;
  final double centerX;
  final Function(int) onTap;
  final List<GlobalKey> iconKeys;

  const BottomNavWithDynamicCurve({
    required this.selectedIndex,
    required this.centerX,
    required this.onTap,
    required this.iconKeys,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 70,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: Size(width, 90),
            painter: NavCurvePainter(centerX: centerX),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final bool isSelected = index == selectedIndex;
                return GestureDetector(
                  key: iconKeys[index],
                  onTap: () => onTap(index),
                  child: Transform.translate(
                    offset: isSelected ? const Offset(0, 5) : const Offset(0, 10),
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: isSelected
                          ? const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      )
                          : null,
                      child: Center(
                        child: SvgPicture.asset(
                          isSelected ? _selectedIcon(index) : _unselectedIcon(index),
                          width: 28,
                          height: 28,
                          color: Color(0xFF7B4FD0),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  String _selectedIcon(int index) {
    switch (index) {
      case 0:
        return 'assets/images/star1.svg';
      case 1:
        return 'assets/images/home_icon1.svg';
      case 2:
        return 'assets/images/out_line1.svg';
      default:
        return '';
    }
  }

  String _unselectedIcon(int index) {
    switch (index) {
      case 0:
        return 'assets/images/home.svg';
      case 1:
        return 'assets/images/info_outline.svg';
      case 2:
        return 'assets/images/star.svg';
      default:
        return '';
    }
  }
}

class NavCurvePainter extends CustomPainter {
  final double centerX;

  NavCurvePainter({required this.centerX});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double curveHeight = 90;
    double curveWidth = 100;
    double edgeCurveWidth = 20;

    Paint paint = Paint()
      ..color = const Color(0xFF110A2B)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, edgeCurveWidth);


    path.quadraticBezierTo(0, 0, edgeCurveWidth, 0);


    path.lineTo(centerX - curveWidth / 2 - 10, 0);
    path.quadraticBezierTo(
      centerX - curveWidth / 2,
      0,
      centerX - curveWidth / 2 + 10,
      20,
    );
    path.quadraticBezierTo(centerX, curveHeight, centerX + curveWidth / 2 - 10, 20);
    path.quadraticBezierTo(
      centerX + curveWidth / 2,
      0,
      centerX + curveWidth / 2 + 10,
      0,
    );


    path.lineTo(width - edgeCurveWidth, 0);
    path.quadraticBezierTo(width, 0, width, edgeCurveWidth);


    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 900) {
      crossAxisCount = 4;
    } else if (screenWidth > 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 2;
    }
    return Stack(
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
                color: Color(0xFF352250), // لون بنفسجي شفاف
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
                color: Color(0xFF9860E4), // لون أفتح شوية
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
                color: Color(0xFF9860E4), // لون أفتح شوية
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
                  color: Color(0xFF40174C) // لون أفتح شوية
              ),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 90),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "About the App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Our application guides you from learning paths to\n"
                        "job readiness by chatting with AI — analyze your\n"
                        "documents, build your CV, and practice\n"
                        "interviews, all in one place.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Our Services",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),


                  GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.86,
                    children: const [
                      _ServiceCard(
                        title: "Roadmap",
                        subtitle: "Discover your learning path",
                        imagePath: 'assets/images/back1.png',
                      ),
                      _ServiceCard(
                        title: "Chat with document",
                        subtitle: "Understand your documents easily",
                        imagePath: 'assets/images/back3.png',
                      ),
                      _ServiceCard(
                        title: "CV Analysis",
                        subtitle: "AI reviews your CV for improvement",
                        imagePath: 'assets/images/back2.png',
                      ),
                      _ServiceCard(
                        title: "Interview",
                        subtitle: "Sharpen your skills before the real talk",
                        imagePath: 'assets/images/home4.png',
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    "Why choose us?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SvgPicture.asset(
                            'assets/images/icon-park-outline_correct.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Everything you need in one App",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SvgPicture.asset(
                            'assets/images/icon-park-outline_correct.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Chat with AI, build your future",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SvgPicture.asset(
                            'assets/images/icon-park-outline_correct.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Realistic interview practice",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SvgPicture.asset(
                            'assets/images/icon-park-outline_correct.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Easy, smart, and fast career support",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  bool get isSvg => imagePath.endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),

      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isSvg
              ? SvgPicture.asset(
            imagePath,
            width: 60,
            height: 60,
          )
              : ClipOval(
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  color: Color(0xFF40174C)
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text(
              'Reviews',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}



