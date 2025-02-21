import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/analyze_resume/resume_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  FormScreenState createState() => FormScreenState();
}

class FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _projectsController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _activitiesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _summaryController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _projectsController.dispose();
    _languagesController.dispose();
    _activitiesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResumeScreen(
            name: _nameController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            linkedin: _linkedinController.text,
            github: _githubController.text,
            summary: _summaryController.text,
            education: _educationController.text,
            skills: _skillsController.text,
            projects: _projectsController.text,
            languages: _languagesController.text,
            activities: _activitiesController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Software Engineer Resume')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter Name' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                 validator: (value) => value!.isEmpty ? 'Enter Phone' : null,
                 keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Basic email validation
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                  },
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _linkedinController,
                decoration: InputDecoration(labelText: 'LinkedIn'),
              ),
              TextFormField(
                controller: _githubController,
                decoration: InputDecoration(labelText: 'GitHub'),
              ),
               TextFormField(
                controller: _summaryController,
                 decoration: InputDecoration(labelText: 'Summary'),
                 maxLines: 3, // Allow multiline input
              ),
              TextFormField(
                controller: _educationController,
                 decoration: InputDecoration(labelText: 'Education'),
                 maxLines: 3,
                ),
              TextFormField(
                controller: _skillsController,
                 decoration: InputDecoration(labelText: 'Skills'),
                  maxLines: 3,
                ),
              TextFormField(
                controller: _projectsController,
                 decoration: InputDecoration(labelText: 'Projects'),
                  maxLines: 3,
                ),
              TextFormField(
                controller: _languagesController,
                 decoration: InputDecoration(labelText: 'Languages'),
                  maxLines: 3,
                ),
              TextFormField(
                controller: _activitiesController,
                 decoration: InputDecoration(labelText: 'Activities'),
                 maxLines: 3,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Generate Resume'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}