import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:road_map_mentor/core/features/build_cv/screens/build_cv_page.dart';
import 'package:road_map_mentor/core/features/chat_with_doc/screens/chatscreen.dart';
import 'package:road_map_mentor/core/features/cv_analysis/screens/cv_analysis_page.dart';
import 'package:road_map_mentor/core/features/interview/screens/interview_page.dart';
import 'package:road_map_mentor/core/features/default_home/screens/default_home_page.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/chat_message_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';

class HomePage extends StatefulWidget {
  final String? username;

  HomePage({this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AboutScreen(),
    ReviewsScreen(),
    ProfileScreen(),
  ];

  final List<Map<String, String>> _fabIcons = [
    {
      'selected': 'assets/images/star1.svg',
      'unselected': 'assets/images/home.svg',
    },
    {
      'selected': 'assets/images/home_icon1.svg',
      'unselected': 'assets/images/info_outline.svg',
    },
    {
      'selected': 'assets/images/out_line1.svg',
      'unselected': 'assets/images/star.svg',
    },
    {
      'selected': 'assets/images/d_home11.svg',
      'unselected': 'assets/images/d_home.svg',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70.98,
            decoration: BoxDecoration(
              color: Color(0xFF150E31),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.purple.shade200,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: List.generate(
                _pages.length,
                (index) {
                  final isSelected = _selectedIndex == index;
                  return BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      _fabIcons[index][isSelected ? 'selected' : 'unselected']!,
                      width: 24,
                      height: 24,
                    ),
                    label: '',
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width /
                    _pages.length *
                    _selectedIndex +
                MediaQuery.of(context).size.width / (_pages.length * 2) -
                30,
            top: -20,
            child: FloatingActionButton(
              onPressed: () => _onItemTapped(_selectedIndex),
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              child: SvgPicture.asset(
                _fabIcons[_selectedIndex]['selected']!,
                width: 30,
                height: 30,
                color: const Color(0xFF6A1B9A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
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
                    shape: BoxShape.circle, color: Color(0xFF40174C)),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              _buildHeader(),
              Expanded(child: _buildServicesList(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("assets/images/user.png"),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hello,",
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text("User!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildServicesList(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildServiceCard(
            context,
            "Roadmap",
            "Talk to Steve to find out which roadmap to follow for your desired track.",
            "assets/images/home1.png",
            "assets/images/Roadmap.png"),
        _buildServiceCard(
            context,
            "Chat With Document",
            "Talk to Serena to discuss your document in detail and get valuable insights.",
            "assets/images/home2.png",
            "assets/images/Chat.png"),
        _buildServiceCard(
            context,
            "CV Analysis",
            "Talk to Marcus to review your CV and find ways to make it stronger.",
            "assets/images/home3.png",
            "assets/images/CV.png"),
        _buildServiceCard(
            context,
            "Interview",
            "Talk to David to prepare for your next big interview with confidence and expert guidance.",
            "assets/images/home4.png",
            "assets/images/Interview.png"),
        _buildServiceCard(
            context,
            "Build CV",
            "Helping you create a CV tailored for the job market by guiding you on what to include",
            null,
            "assets/images/BuildCV.png"),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, String title,
      String description, String? imagePath, String backgroundImagePath) {
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
                Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(description,
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _navigateToService(context, title),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
              child: Image.asset(imagePath,
                  width: 120, height: 120, fit: BoxFit.cover),
            ),
        ],
      ),
    );
  }

  void _navigateToService(BuildContext context, String service) {
    switch (service) {
      case "Roadmap":
        context.go(AppRouter.chatScreen);
        break;
      case "Chat With Document":
        context.go(AppRouter.chatWithDocPage);
        break;
      case "CV Analysis":
        context.go(AppRouter.cvAnalysisPage);
        break;
      case "Interview":
        context.go(AppRouter.interviewPage);
        break;
      case "Build CV":
        context.go(AppRouter.buildCvPage);
        break;
      default:
        return;
    }
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xFF110A2B),
        ),
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
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text(
              'About',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewsScreen extends StatelessWidget {
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
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Reviews",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box('reviews').listenable(),
                    builder: (context, reviewBox, _) {
                      final reviews = reviewBox.values.toList().cast<Map>();

                      return ValueListenableBuilder(
                        valueListenable: Hive.box('feedbacks').listenable(),
                        builder: (context, feedbackBox, _) {
                          final feedbacks =
                              feedbackBox.values.toList().cast<Map>();

                          if (reviews.isEmpty && feedbacks.isEmpty) {
                            return const Center(
                              child: Text(
                                "No reviews or feedback yet",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            );
                          }

                          // Create a map to group feedback and reviews by user
                          Map<String, Map<String, dynamic>> combinedData = {};

                          // Process reviews
                          for (var review in reviews) {
                            String userName = review['name'] ?? "User";
                            if (!combinedData.containsKey(userName)) {
                              combinedData[userName] = {
                                'name': userName,
                                'ratings': review['ratings'],
                                'review': null,
                              };
                            } else {
                              combinedData[userName]!['ratings'] =
                                  review['ratings'];
                            }
                          }

                          // Process feedbacks
                          for (var feedback in feedbacks) {
                            String userName = feedback['name'] ?? "User";
                            if (!combinedData.containsKey(userName)) {
                              combinedData[userName] = {
                                'name': userName,
                                'feedback': feedback['feedback'],
                                'ratings': null,
                              };
                            } else {
                              combinedData[userName]!['feedback'] =
                                  feedback['feedback'];
                            }
                          }

                          // ... existing code ...

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: combinedData.length,
                            itemBuilder: (context, index) {
                              final userData =
                                  combinedData.values.elementAt(index);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage(
                                              'assets/images/user.png'),
                                          backgroundColor: Colors.grey[300],
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          userData['name'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (userData['feedback'] != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Feedback:",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            userData['feedback'],
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      ),
                                    if (userData['ratings'] != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Ratings:",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          ...(userData['ratings'] as Map)
                                              .entries
                                              .map<Widget>((entry) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "${entry.key}",
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children:
                                                        List.generate(5, (i) {
                                                      return Icon(
                                                        i < entry.value
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: Colors.amber,
                                                        size: 18,
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "User";
  String userEmail = "user@gmail.com";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
      extendBodyBehindAppBar: true,
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
                    shape: BoxShape.circle, color: Color(0xFF40174C)),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.rotate(
                                angle: 50.39,
                                child: Container(
                                  width: 291.38,
                                  height: 100.97,
                                  decoration: ShapeDecoration(
                                    shape: OvalBorder(
                                      side: BorderSide(
                                        width: 1.55,
                                        color: Colors.white.withAlpha(28),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: 50.41,
                                child: Container(
                                  width: 229.88,
                                  height: 70.46,
                                  decoration: ShapeDecoration(
                                    shape: OvalBorder(
                                      side: BorderSide(
                                        width: 1.55,
                                        color: Colors.white.withAlpha(28),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: 50.44,
                                child: Container(
                                  width: 200.92,
                                  height: 50.40,
                                  decoration: ShapeDecoration(
                                    shape: OvalBorder(
                                      side: BorderSide(
                                        width: 1.55,
                                        color: Colors.white.withAlpha(28),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/images/user.png'),
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        userName,
                        style: TextStyle(
                          color: const Color(0xFFF5EFFC),
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: const Color(0xFFF5EFFC),
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildProfileButton(
                        context,
                        'Rate our services',
                        SvgPicture.asset(
                          'assets/images/Component.svg',
                          width: 24,
                          height: 24,
                          color: Colors.yellow.shade500,
                        ),
                        Colors.yellow.shade500,
                        RateServices(),
                      ),
                      SizedBox(height: 16),
                      _buildProfileButton(
                        context,
                        'Feedback',
                        SvgPicture.asset(
                          'assets/images/Chat_Round_Check.svg',
                          width: 24,
                          height: 24,
                          color: Colors.green.shade300,
                        ),
                        Colors.green.shade300,
                        Feedback(),
                      ),
                      SizedBox(height: 16),
                      _buildProfileButton(
                        context,
                        'Personal data',
                        SvgPicture.asset(
                          'assets/images/Database.svg',
                          width: 24,
                          height: 24,
                          color: Colors.blue.shade300,
                        ),
                        Colors.blue.shade300,
                        PersonalData(),
                      ),
                      SizedBox(height: 24),
                      _buildTextButton('Logout', () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: Color(0xFF7E46CA),
                                  width: 2,
                                ),
                              ),
                              content: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Are you sure you want to logout?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0xFF7E46CA),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage1()),
                                    );

                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Logged out successfully!')),
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF7E46CA),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                      SizedBox(height: 16),
                      _buildTextButton('Delete account', () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: Color(0xFF7E46CA),
                                  width: 2,
                                ),
                              ),
                              content: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Are you sure you want to delete your account?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0xFF7E46CA),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              Colors.black.withOpacity(0.6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
                                              color: Color(0xFF7E46CA),
                                              width: 2,
                                            ),
                                          ),
                                          content: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                              'Your account has been deleted successfully.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage1()),
                                                );
                                                Future.delayed(
                                                    Duration(milliseconds: 500),
                                                    () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Your account has been deleted successfully')),
                                                  );
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Color(0xFF7E46CA),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF7E46CA),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String text, Widget icon,
      Color iconColor, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                color: const Color(0xFF7E46CA),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            icon,
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF7E46CA),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class RateServices extends StatefulWidget {
  @override
  _RateServicesState createState() => _RateServicesState();
}

class _RateServicesState extends State<RateServices> {
  Map<String, int> ratings = {
    'Roadmap': 0,
    'Analysis CV': 0,
    'Build CV': 0,
    'Chat with document': 0,
    'Interview': 0,
  };

  final TextEditingController _feedbackController = TextEditingController();
  String feedbackText = "";

  Widget _buildRatingItem(String serviceName) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015,
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        children: [
          Expanded(
            child: Text(
              serviceName,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 18,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                iconSize: 23,
                icon: Icon(
                  index < ratings[serviceName]!
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.yellow.shade200,
                ),
                onPressed: () {
                  setState(() {
                    ratings[serviceName] = index + 1;
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _submitRating() {
    String feedbackText = _feedbackController.text.trim();

    final review = {
      "name": "User!",
      "review": feedbackText.isEmpty ? " " : feedbackText,
      "ratings": ratings,
    };

    Hive.box('reviews').add(review);

    print('Rating saved in Hive');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xFF110A2B),
          ),
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
                    shape: BoxShape.circle, color: Color(0xFF40174C)),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 28,
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform.rotate(
                                angle: 50.39,
                                child: Container(
                                  width: 291.38,
                                  height: 100.97,
                                  decoration: ShapeDecoration(
                                    shape: OvalBorder(
                                      side: BorderSide(
                                        width: 1.55,
                                        color: Colors.white.withAlpha(28),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: 50.41,
                                child: Container(
                                  width: 229.88,
                                  height: 70.46,
                                  decoration: ShapeDecoration(
                                    shape: OvalBorder(
                                      side: BorderSide(
                                        width: 1.55,
                                        color: Colors.white.withAlpha(28),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: 50.44,
                                child: Container(
                                  width: 200.92,
                                  height: 50.40,
                                  decoration: ShapeDecoration(
                                    shape: OvalBorder(
                                      side: BorderSide(
                                        width: 1.55,
                                        color: Colors.white.withAlpha(28),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/images/user.png'),
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        'Rate our services',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      _buildRatingItem('Roadmap'),
                      _buildRatingItem('Analysis CV'),
                      _buildRatingItem('Build CV'),
                      _buildRatingItem('Chat with document'),
                      _buildRatingItem('Interview'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _submitRating,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xB27A4DB6),
                                  Color(0xFFDFCEF7),
                                  Color(0xFFF0E7FB),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Rate',
                                style: TextStyle(
                                  color: Color(0xFF352250),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  List<String> feedbacks = []; // List to store all feedbacks

  // Function to handle editing feedback
  Future<void> _editFeedback(int index) async {
    // Open a dialog or a new screen to edit feedback
    String? editedFeedback = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: feedbacks[index]);
        return AlertDialog(
          title: Text(
            "Edit Feedback",
            style: TextStyle(
              color: Color(0xFF7E46CA),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.6),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Color(0xFF7E46CA),
              width: 2,
            ),
          ),
          content: TextField(
            style: TextStyle(
              color: Colors.white,
            ),
            controller: controller,
            decoration: InputDecoration(hintText: "Edit your feedback"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7E46CA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF7E46CA),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (editedFeedback != null && editedFeedback.isNotEmpty) {
      setState(() {
        feedbacks[index] =
            editedFeedback; // Update feedback at the selected index
      });
    }
  }

  void _deleteFeedback(int index) {
    setState(() {
      feedbacks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
      body: SizedBox.expand(
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
                      shape: BoxShape.circle, color: Color(0xFF40174C)),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 20),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: 50.39,
                            child: Container(
                              width: 291.38,
                              height: 100.97,
                              decoration: ShapeDecoration(
                                shape: OvalBorder(
                                  side: BorderSide(
                                    width: 1.55,
                                    color: Colors.white.withAlpha(28),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Transform.rotate(
                            angle: 50.41,
                            child: Container(
                              width: 229.88,
                              height: 70.46,
                              decoration: ShapeDecoration(
                                shape: OvalBorder(
                                  side: BorderSide(
                                    width: 1.55,
                                    color: Colors.white.withAlpha(28),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Transform.rotate(
                            angle: 50.44,
                            child: Container(
                              width: 200.92,
                              height: 50.40,
                              decoration: ShapeDecoration(
                                shape: OvalBorder(
                                  side: BorderSide(
                                    width: 1.55,
                                    color: Colors.white.withAlpha(28),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                              backgroundColor: Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Your Feedbacks',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Click the button below to write your feedback.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 5),
                        ...feedbacks
                            .asMap()
                            .map((index, feedback) {
                              return MapEntry(
                                index,
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: IntrinsicHeight(
                                    child: Container(
                                      width: 380,
                                      padding: EdgeInsets.all(10),
                                      decoration: ShapeDecoration(
                                        color: Colors.white10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              feedback,
                                              style: TextStyle(
                                                color: const Color(0xFFF5EFFC),
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.40,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: SvgPicture.asset(
                                                  'assets/images/Pen_2.svg',
                                                  width: 24,
                                                  height: 24,
                                                  color: Colors.white30,
                                                ),
                                                onPressed: () =>
                                                    _editFeedback(index),
                                              ),
                                              IconButton(
                                                icon: SvgPicture.asset(
                                                  'assets/images/Trash_Bin_Minimalistic.svg',
                                                  width: 24,
                                                  height: 24,
                                                  color: Colors.white30,
                                                ),
                                                onPressed: () =>
                                                    _deleteFeedback(index),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                            .values
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Color(0xFF9860E4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            String? feedback = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WriteFeedbackScreen()),
            );
            if (feedback != null && feedback.isNotEmpty) {
              setState(() {
                feedbacks.add(feedback);
              });
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class WriteFeedbackScreen extends StatefulWidget {
  @override
  _WriteFeedbackScreenState createState() => _WriteFeedbackScreenState();
}

class _WriteFeedbackScreenState extends State<WriteFeedbackScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
      body: Stack(
        children: [
          Container(
            color: Color(0xFF110A2B),
          ),
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
                    shape: BoxShape.circle, color: Color(0xFF40174C)),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 28,
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: 50.39,
                        child: Container(
                          width: 291.38,
                          height: 100.97,
                          decoration: ShapeDecoration(
                            shape: OvalBorder(
                              side: BorderSide(
                                width: 1.55,
                                color: Colors.white.withAlpha(28),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: 50.41,
                        child: Container(
                          width: 229.88,
                          height: 70.46,
                          decoration: ShapeDecoration(
                            shape: OvalBorder(
                              side: BorderSide(
                                width: 1.55,
                                color: Colors.white.withAlpha(28),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: 50.44,
                        child: Container(
                          width: 200.92,
                          height: 50.40,
                          decoration: ShapeDecoration(
                            shape: OvalBorder(
                              side: BorderSide(
                                width: 1.55,
                                color: Colors.white.withAlpha(28),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/user.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'Feedback',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _controller,
                        style: TextStyle(color: Colors.white),
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Write your feedback about our services...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            String feedbackText = _controller.text.trim();
                            if (feedbackText.isNotEmpty) {
                              final box = Hive.box('feedbacks');
                              box.add({
                                'name': "user",
                                'feedback': feedbackText,
                                'timestamp': DateTime.now().toString(),
                              });
                              Navigator.pop(context, feedbackText);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60, // حجم الزر
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF7A4DB6),
                                  Color(0xFFDFCEF7),
                                  Color(0xFFF0E7FB),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: Color(0xFF352250),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PersonalData extends StatefulWidget {
  // Changed to StatefulWidget
  @override
  _PersonalDataState createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  bool _isEditing = false;
  String _username = 'user';
  String _email = 'user@gmail.com';
  String _joinDate = '04-02-2025';
  String _password = '1234';

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _joinDateController;
  late TextEditingController _passwordController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: _username);
    _emailController = TextEditingController(text: _email);
    _joinDateController = TextEditingController(text: _joinDate);
    _passwordController = TextEditingController(text: _password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _joinDateController.dispose();
    _passwordController.dispose();
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
                    shape: BoxShape.circle, color: Color(0xFF40174C)),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: 50.39,
                          child: Container(
                            width: 291.38,
                            height: 100.97,
                            decoration: ShapeDecoration(
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 1.55,
                                  color: Colors.white.withAlpha(28),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: 50.41,
                          child: Container(
                            width: 229.88,
                            height: 70.46,
                            decoration: ShapeDecoration(
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 1.55,
                                  color: Colors.white.withAlpha(28),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: 50.44,
                          child: Container(
                            width: 200.92,
                            height: 50.40,
                            decoration: ShapeDecoration(
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 1.55,
                                  color: Colors.white.withAlpha(28),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/user.png'),
                            backgroundColor: Colors.transparent,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 30),
                      _buildTextField(
                        labelText: 'UserName',
                        controller: _usernameController,
                        enabled: _isEditing,
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        labelText: 'Email',
                        controller: _emailController,
                        enabled: _isEditing,
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        labelText: 'Join date',
                        controller: _joinDateController,
                        enabled: false,
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        labelText: 'Password',
                        controller: _passwordController,
                        enabled: _isEditing,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: _obscurePassword
                              ? SvgPicture.asset(
                                  'image/eye-off.svg',
                                  width: 24,
                                  height: 24,
                                  color: Colors.white70,
                                )
                              : SvgPicture.asset(
                                  'image/eye.svg',
                                  width: 24,
                                  height: 24,
                                  color: Colors.white70,
                                ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                            if (!_isEditing) {
                              print('Username: ${_usernameController.text}');
                              print('Email: ${_emailController.text}');
                              print('Password: ${_passwordController.text}');

                              _username = _usernameController.text;
                              _email = _emailController.text;
                              _password = _passwordController.text;
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF7A4DB6),
                                Color(0xFFDFCEF7),
                                Color(0xFFF0E7FB)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              _isEditing ? 'Save' : 'Edit',
                              style: TextStyle(
                                color: Color(0xFF352250),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required bool enabled,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: const Color(0xFF605B6C),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color(0xFF605B6C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.purpleAccent),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
