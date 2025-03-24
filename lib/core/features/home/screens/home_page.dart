import 'package:flutter/material.dart';
import 'package:flutter_app/build_cv_page.dart';
import 'package:flutter_app/chat_with_doc_page.dart';
import 'package:flutter_app/cv_analysis_page.dart';
import 'package:flutter_app/interview_page.dart';
import 'package:flutter_app/roadmap_page.dart';

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

  final List<double> _fabPositions = [48, 160, 280, 400];

  final List<IconData> _fabIcons = [
    Icons.home,
    Icons.info_outline,
    Icons.star,
    Icons.person,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1A47),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 80.98,
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
              items: [
                BottomNavigationBarItem(
                  icon: _selectedIndex == 0 ? SizedBox.shrink() : Icon(Icons.home),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: _selectedIndex == 1 ? SizedBox.shrink() : Icon(Icons.info_outline),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: _selectedIndex == 2 ? SizedBox.shrink() : Icon(Icons.star_border),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: _selectedIndex == 3 ? SizedBox.shrink() : Icon(Icons.person_outline),
                  label: "",
                ),
              ],
            ),
          ),
          Positioned(
            left: _fabPositions[_selectedIndex],
            top: -20,
            child: FloatingActionButton(
              onPressed: () => _onItemTapped(_selectedIndex),
              backgroundColor: Colors.white,
              shape: CircleBorder(),
              child: Icon(
                _fabIcons[_selectedIndex],
                color: Color(0xFF6A1B9A),
                size: 30,
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
      backgroundColor: Color(0xFF2E1055),
      body: Column(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("image/user.png"),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hello,", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text("User!", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
        _buildServiceCard(context, "Roadmap", "Talk to Steve to find out which roadmap to follow for your desired track.", "image/home1.png"),
        _buildServiceCard(context, "Chat With Document", "Talk to Serena to discuss your document in detail and get valuable insights.", "image/home2.png"),
        _buildServiceCard(context, "CV Analysis", "Talk to Marcus to review your CV and find ways to make it stronger.", "image/home3.png"),
        _buildServiceCard(context, "Interview", "Talk to David to prepare for your next big interview with confidence and expert guidance.", "image/home4.png"),
        _buildServiceCard(context, "Build CV", "Helping you create a CV tailored for the job market by guiding you on what to include", "image/home4.png"),
      ],
    );
  }


  Widget _buildServiceCard(BuildContext context, String title, String description, String imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF4C1D95),
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
                  child: Text("Get Started"),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imagePath, width: 120, height: 120, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }


  void _navigateToService(BuildContext context, String service) {
    Widget page;
    switch (service) {
      case "Roadmap":
        page = RoadmapPage();
        break;
      case "Chat With Document":
        page = ChatWithDocPage();
        break;
      case "CV Analysis":
        page = CvAnalysisPage();
        break;
      case "Interview":
        page = InterviewPage();
        break;
      case "Build CV":
        page = BuildCvPage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}


class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1A47),
      body: Center(
        child: Text(
          "This app helps you create a professional resume easily!",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}



class ReviewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {"name": "Jomana Peters", "review": "The service is so great!", "rating": 4.5},
    {"name": "Maria Peters", "review": "Useful and easy-to-use app", "rating": 5.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1A47),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            "evaluations",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  color: Color(0xFF4C1D95),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(review["name"], style: TextStyle(color: Colors.white)),
                    subtitle: Text(review["review"], style: TextStyle(color: Colors.white70)),
                    trailing: Icon(Icons.star, color: Colors.amber),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E1A47),
      body: Center(
        child: Text(
          "👤 User Profile",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

