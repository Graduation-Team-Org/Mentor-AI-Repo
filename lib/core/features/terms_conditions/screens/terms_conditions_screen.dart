import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
        backgroundColor: Color(0xFF2E1A47),
      ),
      backgroundColor: Color(0xFF2E1A47),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "1. By using this app, you agree to follow our rules and policies.\n"
                    "2. Your personal data will be handled securely and will not be shared without your consent.\n"
                    "3. The app is not responsible for any misuse of information provided by users.\n"
                    "4. You must be at least 18 years old to use this app.\n"
                    "5. We reserve the right to modify these terms at any time.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Accept & Close"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7A4DB6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
