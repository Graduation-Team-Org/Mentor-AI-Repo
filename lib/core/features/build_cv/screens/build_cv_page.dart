import 'dart:ui';
import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

class BuildCvPage extends StatefulWidget {
  @override
  _BuildCVPageState createState() => _BuildCVPageState();
}

class _BuildCVPageState extends State<BuildCvPage> with SingleTickerProviderStateMixin {

  final TextEditingController _projectStartDateController = TextEditingController();
  final TextEditingController _projectEndDateController = TextEditingController();
  final TextEditingController _internshipStartDateController = TextEditingController();
  final TextEditingController _internshipEndDateController = TextEditingController();
  final TextEditingController _experienceStartDateController = TextEditingController();
  final TextEditingController _experienceEndDateController = TextEditingController();


  late TabController _tabController;
  late Box cvDataBox;


  List<String> softSkills = [
    "Communication", "Teamwork", "Problem Solving", "Adaptability", "Creativity",
    "Time Management", "Leadership", "Critical Thinking", "Conflict Resolution",
    "Decision Making", "Emotional Intelligence", "Collaboration", "Flexibility",
    "Interpersonal Skills", "Work Ethic", "Stress Management", "Positive Attitude",
    "Negotiation", "Active Listening", "Motivation", "Presentation Skills", "Networking",
    "Self-Confidence", "Organizational Skills", "Attention to Detail", "Multi-tasking",
    "Delegation", "Public Speaking", "Cultural Awareness", "Mentoring", "Self-Discipline",
    "Accountability", "Open-Mindedness", "Empathy", "Self-Motivation", "Patience", "Reliability",
    "Innovation", "Resourcefulness"
  ];

  List<String> technicalSkills = [
    'Java', 'C++', 'Python', 'Dart', 'Flutter', 'JavaScript', 'HTML', 'CSS',
    'PHP', 'Swift', 'Kotlin', 'Ruby', 'SQL', 'Database Management',
    'Machine Learning', 'AI', 'Cloud Computing', 'Data Analysis', 'UX/UI Design',
    'Web Development', 'App Development', 'Cybersecurity', 'Project Management'
  ];

  List<String> selectedSoftSkills = [];
  List<String> selectedTechnicalSkills = [];
  List<String> selectedLanguages = ['English'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
    _initializeHive();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Future<void> _initializeHive() async {
    cvDataBox = await Hive.openBox('cvDataBox');
  }


  void _saveData(String key, String value) {
    cvDataBox.put(key, value);
  }


  String _getData(String key) {
    return cvDataBox.get(key, defaultValue: "");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeHive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
                          color: Color(0xFF40174C)
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            'Build CV',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepPurpleAccent[100],
                        ),
                        indicatorColor: Colors.transparent,
                        isScrollable: true,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: [
                          Tab(text: 'Personal Info'),
                          Tab(text: 'Summary'),
                          Tab(text: 'Education'),
                          Tab(text: 'Projects'),
                          Tab(text: 'Activities'),
                          Tab(text: 'Internship'),
                          Tab(text: 'Experience'),
                          Tab(text: 'Language'),
                          Tab(text: 'Skills'),
                          Tab(text: 'Export'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(child: _buildPersonalInfo()),
                          SingleChildScrollView(child: _buildSummary()),
                          SingleChildScrollView(child: _buildEducation()),
                          SingleChildScrollView(child: _buildProjects()),
                          SingleChildScrollView(child: _buildActivities()),
                          SingleChildScrollView(child: _buildInternship()),
                          SingleChildScrollView(child: _buildExperience()),
                          SingleChildScrollView(child: _buildLanguage()),
                          SingleChildScrollView(child: _buildSkills()),
                          SingleChildScrollView(child: _buildExport()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading data: ${snapshot.error}"));
        }
        else {
          return Center(child: CircularProgressIndicator());
        }

      },
    );
  }


  Widget _customTextField(String label, String key,  {TextEditingController? controller, int? maxLines} ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: maxLines ?? 1,
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          _saveData(key, value);
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.white10,
          filled: true,
        ),
      ),
    );
  }


  Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    double height = 55,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
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
            text,
            style: TextStyle(
              color: Color(0xFF352250),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTabContent(List<Widget> children) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );

  Widget _buildPersonalInfo() => _buildTabContent([
    _customTextField('Enter full name', 'fullName'),
    _customTextField('Email', 'email'),
    _customTextField('Phone number', 'phone'),
    _customTextField('LinkedIn profile link', 'linkedin'),
    _customTextField('GitHub profile link', 'github'),

    gradientButton(
      text: "Next",
      onPressed: () {
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);


  Widget _buildSummary() => _buildTabContent([
    _customTextField(
        'Please provide a brief descrption about yourself,hightlighting your interests',
        'summary', maxLines: 8),
    gradientButton(
      text: "Next",
      onPressed: () {
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);


  Widget _buildEducation() => _buildTabContent([
    _customTextField("University Name", 'universityName'),
    _customTextField('Degree Name', 'degreeName'),
    _customTextField('Country', 'educationCountry'),
    _customTextField('GPA', 'gpa'),

    gradientButton(
      text: "Next",
      onPressed: () {
        final edu = '${_getData("degreeName")} at ${_getData(
            "universityName")} (${_getData(
            "educationCountry")}) - GPA: ${_getData("gpa")}';
        _saveData('education', edu);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);


  Widget _buildProjects() => _buildTabContent([
    _customTextField('Project Title', 'projectTitle'),
    _customTextField('Project Link', 'projectLink'),

    // Start Date TextField with DatePicker
    GestureDetector(
      onTap: () => _selectDate(context, 'projectStartDate'),
      child: AbsorbPointer(
        child: _customTextField('Start Date', 'projectStartDate' , controller: _projectStartDateController),
      ),
    ),

    // End Date TextField with DatePicker
    GestureDetector(
      onTap: () => _selectDate(context, 'projectEndDate'),
      child: AbsorbPointer(
        child: _customTextField('End Date', 'projectEndDate' , controller: _projectEndDateController),
      ),
    ),

    _customTextField(
        'Summary about project', 'projectSummary', maxLines: 7),

    gradientButton(
      text: "Next",
      onPressed: () {
        final project = '${_getData("projectTitle")} (${_getData(
            "projectStartDate")} - ${_getData(
            "projectEndDate")}): ${_getData("projectSummary")}';
        _saveData('project', project);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);


  Widget _buildActivities() => _buildTabContent([
    _customTextField('Feel free to share your personal activities and achievements  that make you shine!', 'activitiesAchievements', maxLines: 10),

    gradientButton(
      text: "Next",
      onPressed: () {
        _saveData('activities', _getData('activitiesAchievements'));
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);


  Widget _buildInternship() => _buildTabContent([
    _customTextField('Organization Name', 'internshipOrganization'),
    _customTextField('Country', 'internshipCountry'),

    GestureDetector(
      onTap: () => _selectDate(context, 'internshipStartDate'),
      child: AbsorbPointer(
        child: _customTextField('Start Date', 'internshipStartDate', controller: _internshipStartDateController),
      ),
    ),

    // End Date TextField with DatePicker
    GestureDetector(
      onTap: () => _selectDate(context, 'internshipEndDate'),
      child: AbsorbPointer(
        child: _customTextField('End Date', 'internshipEndDate' , controller: _internshipEndDateController),
      ),
    ),

    _customTextField('Provide a brief description about internship', 'internshipDescription', maxLines: 5),

    gradientButton(
      text: "Next",
      onPressed: () {
        final internship = '${_getData("internshipOrganization")} (${_getData("internshipCountry")}) - ${_getData("internshipStartDate")} to ${_getData("internshipEndDate")}: ${_getData("internshipDescription")}';
        _saveData('internship', internship);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);


  Widget _buildExperience() => _buildTabContent([
    _customTextField('Job Title/Position', 'jobTitle'),
    _customTextField('Company Name', 'companyName'),

    GestureDetector(
      onTap: () => _selectDate(context, 'experienceStartDate'),
      child: AbsorbPointer(
        child: _customTextField('Start Date', 'experienceStartDate' , controller: _experienceStartDateController),
      ),
    ),

    GestureDetector(
      onTap: () => _selectDate(context, 'experienceEndDate'),
      child: AbsorbPointer(
        child: _customTextField('End Date', 'experienceEndDate' , controller: _experienceEndDateController),
      ),
    ),

    _customTextField('Your Experience', 'experienceDescription', maxLines: 5),

    gradientButton(
      text: "Next",
      onPressed: () {
        final exp = '${_getData("jobTitle")} at ${_getData("companyName")} (${_getData("experienceStartDate")} - ${_getData("experienceEndDate")}): ${_getData("experienceDescription")}';
        _saveData('experience', exp);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);


  Widget _buildLanguage() {
    List<String> languages = [
      'English', 'French', 'German', 'Arabic', 'Spanish', 'Italian', 'Portuguese', 'Russian', 'Chinese', 'Japanese',
      'Korean', 'Hindi', 'Dutch', 'Turkish', 'Swedish', 'Norwegian', 'Polish', 'Greek', 'Hebrew', 'Swahili', 'Bengali', 'Tamil', 'Punjabi', 'Gujarati', 'Malayalam', 'Marathi', 'Telugu', 'Urdu', 'Thai', 'Vietnamese', 'Indonesian', 'Filipino', 'Finnish', 'Czech', 'Hungarian', 'Romanian', 'Danish',
      'Bulgarian', 'Slovak', 'Ukrainian', 'Croatian', 'Serbian', 'Slovenian',
      'Lithuanian', 'Latvian', 'Estonian', 'Icelandic', 'Basque', 'Catalan', 'Welsh', 'Galician',
      'Maltese', 'Afrikaans', 'Xhosa', 'Zulu', 'Amharic', 'Somali', 'Haitian Creole', 'Esperanto', 'Quechua',
      'Māori', 'Hmong', 'Yiddish', 'Armenian', 'Georgian', 'Albanian', 'Bosnian', 'Macedonian', 'Malay',
      'Kurdish', 'Khmer', 'Sinhalese', 'Burmese', 'Laotian', 'Nepali', 'Tajik', 'Kazakh', 'Uzbek', 'Azerbaijani', 'Tatar', 'Turkmen', 'Bashkir',

    ];

    return StatefulBuilder(
      builder: (context, setState) => _buildTabContent([
        Text("Select Languages", style: TextStyle(color: Colors.white, fontSize: 18)),
        ...selectedLanguages.asMap().entries.map((entry) {
          int index = entry.key;
          String value = entry.value;
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: languages.contains(value) ? value : null,
                  dropdownColor: Color(0xFF7A4DB6),
                  items: languages.map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),),
                  )).toList(),
                  onChanged: (newValue) => setState(() => selectedLanguages[index] = newValue!),

                  decoration: InputDecoration(

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.white10,
                    filled: true,
                  ),
                ),
              ),
              if (index > 0)
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.white30),
                  onPressed: () => setState(() => selectedLanguages.removeAt(index)),
                )
            ],
          );
        }),
        TextButton.icon(
          onPressed: () {
            final newLang = languages.firstWhere(
                    (lang) => !selectedLanguages.contains(lang),
                orElse: () => '');
            if (newLang.isNotEmpty) {
              setState(() => selectedLanguages.add(newLang));
            }
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text("Add Language", style: TextStyle(color: Colors.white)),
        ),

        gradientButton(
          text: "Next",
          onPressed: () {
            _saveData('languages', selectedLanguages.join(', '));
            _tabController.animateTo(_tabController.index + 1);
          },
        ),
      ]),
    );
  }


  Widget _buildSkills() => Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkillCategory("Soft Skills", softSkills, selectedSoftSkills),
        _buildSkillCategory("Technical Skills", technicalSkills, selectedTechnicalSkills),

        gradientButton(
          text: "Next",
          onPressed: () {
            _saveData('skills', [
              ...selectedSoftSkills,
              ...selectedTechnicalSkills,
            ].join(', '));
            _tabController.animateTo(_tabController.index + 1);
          },
        ),

      ],
    ),
  );


  Widget _buildSkillCategory(String title, List<String> skills, List<String> selectedSkills) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () => _showSkillSelectionDialog(skills, selectedSkills),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.white)),
              Icon(Icons.add_circle_outline, color: Colors.white),
            ],
          ),
        ),
      ),
      SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: selectedSkills.map((skill) => Chip(
          label: Text(skill),
          backgroundColor: Colors.purple.shade700,
          labelStyle: TextStyle(color: Colors.white),
          deleteIcon: Icon(Icons.close, size: 18, color: Colors.white),
          onDeleted: () => setState(() => selectedSkills.remove(skill)),
        )).toList(),
      ),
      SizedBox(height: 16),
    ],
  );

  void _showSkillSelectionDialog(List<String> skills, List<String> selectedSkills) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Skills", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF352250),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: skills.map((skill) {
                return ListTile(
                  title: Text(skill, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    if (!selectedSkills.contains(skill)) {
                      setState(() {
                        selectedSkills.add(skill);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExport() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getData('fullName'),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 8),
                // Contact Info
                Row(
                  children: [
                    Icon(Icons.email_outlined, color: Colors.grey.shade600, size: 16),
                    SizedBox(width: 4),
                    Text("${_getData('email')}  |  ", style: TextStyle(color: Colors.black)),
                    Icon(Icons.phone_outlined, color: Colors.grey.shade600, size: 16),
                    SizedBox(width: 4),
                    Text("${_getData('phone')}  |  ", style: TextStyle(color: Colors.black)),
                    if (_getData('linkedin').isNotEmpty) ...[
                      Icon(Icons.link, color: Colors.grey.shade600, size: 16),
                      SizedBox(width: 4),
                      Expanded(child: Text("${_getData('linkedin')}  |  ", style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis)),
                    ],
                    if (_getData('github').isNotEmpty) ...[
                      Icon(Icons.code, color: Colors.grey.shade600, size: 16),
                      SizedBox(width: 4),
                      Expanded(child: Text(_getData('github'), style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis)),
                    ],
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                SizedBox(height: 16),

                // Summary
                Text("Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Text(_getData('summary'), style: TextStyle(color: Colors.black)),
                SizedBox(height: 16),

                // Education
                Text("Education", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Text(_getData('education'), style: TextStyle(color: Colors.black)),
                SizedBox(height: 16),

                // Project
                Text("Project", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Text(_getData('project'), style: TextStyle(color: Colors.black)),
                SizedBox(height: 16),

                // Activities
                Text("Activities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Text(_getData('activities'), style: TextStyle(color: Colors.black)),
                SizedBox(height: 16),

                // Internship
                Text("Internship", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Text(_getData('internship'), style: TextStyle(color: Colors.black)),
                SizedBox(height: 16),

                // Experience
                Text("Experience", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Text(_getData('experience'), style: TextStyle(color: Colors.black)),
                SizedBox(height: 16),

                // Languages
                Text("Languages", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: _getData('languages').split(', ').map((lang) => Chip(label: Text(lang))).toList(),
                ),
                SizedBox(height: 16),

                // Skills
                Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: _getData('skills').split(', ').map((skill) => Chip(label: Text(skill))).toList(),
                ),
              ],
            ),
          ),

        ),
        SizedBox(height: 20),
        // Export to PDF Button
        Column(
          children: [
            GestureDetector(
              onTap: _exportToPdf,
              child: Container(
                width: double.infinity,
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Color(0xFF7A4DB6), Color(0xFFDFCEF7), Color(0xFFF0E7FB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf, color: Color(0xFF352250)),
                    SizedBox(width: 8),
                    Text(
                      "Export to PDF",
                      style: TextStyle(
                        color: Color(0xFF352250),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
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

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();

    final headerStyle = pw.TextStyle(
      fontSize: 22,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );

    final sectionTitleStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );



    final normalTextStyle = const pw.TextStyle(fontSize: 12);
    final smallTextStyle = const pw.TextStyle(fontSize: 10, color: PdfColors.grey600);

    final sectionTitle = (String title) => pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12, bottom: 6),
      child: pw.Text(title, style: sectionTitleStyle),
    );

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Full Name (Centered)
              pw.Center(
                child: pw.Text(
                  _getData('fullName'),
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#000000'),
                  ),
                ),
              ),
              pw.SizedBox(height: 8),

              // Contact Info (Centered without large divider)
              pw.Center(
                child: pw.Text(
                  "P: ${_getData('phone')} | ${_getData('email')} | ${_getData('linkedin')} | ${_getData('github')}",
                  style: smallTextStyle,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 16),

              // Section Title (Summary) with Divider
              sectionTitle("Summary"),
              pw.Divider(),
              pw.Text(_getData('summary'), style: normalTextStyle),
              pw.SizedBox(height: 16),

              // Education Section with Divider
              sectionTitle("Education"),
              pw.Divider(),
              pw.Text(_getData('education'), style: normalTextStyle),
              pw.SizedBox(height: 16),

              // Experience Section with Divider
              sectionTitle("Experience"),
              pw.Divider(),
              pw.Text(_getData('experience'), style: normalTextStyle),
              pw.SizedBox(height: 16),

              // Internship Section with Divider
              sectionTitle("Internship"),
              pw.Divider(),
              pw.Text(_getData('internship'), style: normalTextStyle),
              pw.SizedBox(height: 16),

              // Projects Section with Divider
              sectionTitle("Projects"),
              pw.Divider(),
              pw.Text(_getData('project'), style: normalTextStyle),
              pw.SizedBox(height: 16),

              // Activities Section with Divider
              sectionTitle("Activities"),
              pw.Divider(),
              pw.Text(_getData('activities'), style: normalTextStyle),
              pw.SizedBox(height: 16),

              // Languages Section with Divider
              sectionTitle("Languages"),
              pw.Divider(),
              pw.Text(_getData('languages'), style: normalTextStyle),
              pw.SizedBox(height: 16),

              // Skills Section with Divider
              sectionTitle("Skills"),
              pw.Divider(),
              pw.Text(_getData('skills'), style: normalTextStyle),
            ],
          ),
        ],
      ),
    );






    final pdfBytes = await pdf.save();

    // Replace the web-specific code with mobile-specific code
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/cv.pdf");
    await file.writeAsBytes(pdfBytes);
    
    // Share the PDF file
    await Share.shareXFiles([XFile(file.path)], text: 'My Resume');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF saved and ready to share"))
    );
  }


  Future<void> _selectDate(BuildContext context, String field) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      _saveData(field, formattedDate);
      if (field == 'projectStartDate') {
        _projectStartDateController.text = formattedDate;
      } else if (field == 'projectEndDate') {
        _projectEndDateController.text = formattedDate;
      }

      _saveData(field, formattedDate);
      if (field == 'internshipStartDate') {
        _internshipStartDateController.text = formattedDate;
      } else if (field == 'internshipEndDate') {
        _internshipEndDateController.text = formattedDate;
      }

      _saveData(field, formattedDate);
      if (field == 'experienceStartDate') {
        _experienceStartDateController.text = formattedDate;
      } else if (field == 'experienceEndDate') {
        _experienceEndDateController.text = formattedDate;
      }
    }
  }



}


