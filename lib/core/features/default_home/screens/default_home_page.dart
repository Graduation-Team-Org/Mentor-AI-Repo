import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/sign_up/screens/signup_screen.dart';

class HomePage1 extends StatelessWidget {
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
      bottomNavigationBar: _buildBottomNavBar(),
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
              Text.rich(
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
              const SizedBox(width: 3),
              Image.asset(
                'image/image.png',
                width: 40,
                height: 40,
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Meet our expert AI mentors to gain valuable knowledge and experience.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
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
        gradient: LinearGradient(
          colors: [
            Color(0xFFB183FF),
            Color(0xFF1A0130),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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



  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF2E1055),
      selectedItemColor: Colors.pinkAccent,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
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
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.7),
                      border: Border.all(color: Color(0xFF9860E4), width: 1.5),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 15),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.all(4),
                      constraints: BoxConstraints(),
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
}
