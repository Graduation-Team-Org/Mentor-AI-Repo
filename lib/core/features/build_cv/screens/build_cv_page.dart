import 'dart:ui';
import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class BuildCvPage extends StatefulWidget {
  @override
  State<BuildCvPage> createState() => _BuildCVPageState();
}

class _BuildCVPageState extends State<BuildCvPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late Box cvDataBox;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController universityNameController = TextEditingController();
  final TextEditingController degreeNameController = TextEditingController();
  final TextEditingController educationCountryController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();
  final TextEditingController projectTitleController = TextEditingController();
  final TextEditingController projectLinkController = TextEditingController();
  final TextEditingController projectSummaryController = TextEditingController();
  final TextEditingController _projectStartDateController = TextEditingController();
  final TextEditingController _projectEndDateController = TextEditingController();
  final TextEditingController activitiesController = TextEditingController();
  final TextEditingController internshipOrganizationController = TextEditingController();
  final TextEditingController internshipCountryController = TextEditingController();
  final TextEditingController internshipDescriptionController = TextEditingController();
  final TextEditingController _internshipStartDateController = TextEditingController();
  final TextEditingController _internshipEndDateController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController experienceDescriptionController = TextEditingController();
  final TextEditingController _experienceStartDateController = TextEditingController();
  final TextEditingController _experienceEndDateController = TextEditingController();

  List<String> softSkills = [
    "Communication",
    "Teamwork",
    "Problem Solving",
    "Adaptability",
    "Creativity",
    "Time Management",
    "Leadership",
    "Critical Thinking",
    "Conflict Resolution",
    "Decision Making",
    "Emotional Intelligence",
    "Collaboration",
    "Flexibility",
    "Interpersonal Skills",
    "Work Ethic",
    "Stress Management",
    "Positive Attitude",
    "Negotiation",
    "Active Listening",
    "Motivation",
    "Presentation Skills",
    "Networking",
    "Self-Confidence",
    "Organizational Skills",
    "Attention to Detail",
    "Multi-tasking",
    "Delegation",
    "Public Speaking",
    "Cultural Awareness",
    "Mentoring",
    "Self-Discipline",
    "Accountability",
    "Open-Mindedness",
    "Empathy",
    "Self-Motivation",
    "Patience",
    "Reliability",
    "Innovation",
    "Resourcefulness"
  ];

  List<String> technicalSkills = [
    'Java',
    'C++',
    'Python',
    'Dart',
    'Flutter',
    'JavaScript',
    'HTML',
    'CSS',
    'PHP',
    'Swift',
    'Kotlin',
    'Ruby',
    'SQL',
    'Database Management',
    'Machine Learning',
    'AI',
    'Cloud Computing',
    'Data Analysis',
    'UX/UI Design',
    'Web Development',
    'App Development',
    'Cybersecurity',
    'Project Management'
  ];

  List<String> selectedSoftSkills = [];
  List<String> selectedTechnicalSkills = [];
  List<String> selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
    _initializeData();
  }

  void _initializeData() async {
    await _initializeHive();
    fullNameController.text = _getData('fullName');
    emailController.text = _getData('email');
    phoneController.text = _getData('phone');
    linkedinController.text = _getData('linkedin');
    githubController.text = _getData('github');
    summaryController.text = _getData('summary');
    universityNameController.text = _getData('universityName');
    degreeNameController.text = _getData('degreeName');
    educationCountryController.text = _getData('educationCountry');
    gpaController.text = _getData('gpa');
    projectTitleController.text = _getData('projectTitle');
    projectLinkController.text = _getData('projectLink');
    projectSummaryController.text = _getData('projectSummary');
    _projectStartDateController.text = _getData('projectStartDate');
    _projectEndDateController.text = _getData('projectEndDate');
    activitiesController.text = _getData('activities');
    internshipOrganizationController.text = _getData('internshipOrganization');
    internshipCountryController.text = _getData('internshipCountry');
    internshipDescriptionController.text = _getData('internshipDescription');
    _internshipStartDateController.text = _getData('internshipStartDate');
    _internshipEndDateController.text = _getData('internshipEndDate');
    jobTitleController.text = _getData('jobTitle');
    companyNameController.text = _getData('companyName');
    experienceDescriptionController.text = _getData('experienceDescription');
    _experienceStartDateController.text = _getData('experienceStartDate');
    _experienceEndDateController.text = _getData('experienceEndDate');

    final savedSoft = _getData('softSkills');
    selectedSoftSkills = savedSoft.isNotEmpty
        ? savedSoft.split(', ').map((s) => s.trim()).toList()
        : [];

    final savedTech = _getData('technicalSkills');
    selectedTechnicalSkills = savedTech.isNotEmpty
        ? savedTech.split(', ').map((s) => s.trim()).toList()
        : [];

    final savedLanguages = _getData('languages');
    selectedLanguages = savedLanguages.isNotEmpty
        ? savedLanguages.split(', ').map((e) => e.trim()).toList()
        : [''];

    setState(() {});
  }


  Future<void> _initializeHive() async {
    cvDataBox = await Hive.openBox('cvDataBox');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  void _saveData(String key, String value) {
    cvDataBox.put(key, value);
  }

  String _getData(String key) {
    return cvDataBox.get(key, defaultValue: "");
  }

  String formatDate(String inputDate) {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parse(inputDate);
      return DateFormat('MMM yyyy').format(parsedDate);
    } catch (e) {
      return inputDate;
    }
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
                    Padding(
                      padding:  const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
                      child: Container(
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

                    ),
                    SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 3),
                      padding: EdgeInsets.symmetric(
                          horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),



                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF9860E4),
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        indicatorColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,


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
        controller: controller,
        maxLines: maxLines ?? 1,
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          _saveData(key, value);
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70, fontSize: 14),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF9860E4),),
            borderRadius: BorderRadius.circular(10),
          ),

        ),

      ),
    );
  }

  Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    double height = 50,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: height,
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
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );

  Widget _buildPersonalInfo() => _buildTabContent([
    _customTextField('Enter full name', 'fullName', controller: fullNameController),
    _customTextField('Email', 'email', controller: emailController),
    _customTextField('Phone number', 'phone', controller: phoneController),
    _customTextField('LinkedIn profile link', 'linkedin', controller: linkedinController),
    _customTextField('GitHub profile link', 'github', controller: githubController),
    SizedBox(height: 20),
    gradientButton(
      text: "Next",
      onPressed: () {
        _saveData('fullName', fullNameController.text);
        _saveData('email', emailController.text);
        _saveData('phone', phoneController.text);
        _saveData('linkedin', linkedinController.text);
        _saveData('github', githubController.text);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);

  Widget _buildSummary() => _buildTabContent([
    _customTextField(
        'Please provide a brief descrption about yourself,hightlighting your interests',
        'summary', maxLines: 8,
        controller: summaryController

    ),
    SizedBox(height: 20),
    gradientButton(
      text: "Next",
      onPressed: () {
        _saveData('summary', summaryController.text);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);

  Widget _buildEducation() => _buildTabContent([
    _customTextField("School/Collage/University Name", 'universityName', controller: universityNameController),
    _customTextField('Course/Degree Name', 'degreeName', controller: degreeNameController),
    _customTextField('Country', 'educationCountry', controller: educationCountryController),
    _customTextField('GPA', 'gpa', controller: gpaController),

    SizedBox(height: 20),
    gradientButton(
      text: "Next",
      onPressed: () {
        _saveData('universityName', universityNameController.text);
        _saveData('degreeName', degreeNameController.text);
        _saveData('educationCountry', educationCountryController.text);
        _saveData('gpa', gpaController.text);

        final educationFormatted = '${universityNameController.text}  '
            ' ${degreeNameController.text} '
            '${educationCountryController.text} '
            'GPA: ${gpaController.text}';
        _saveData('education', educationFormatted);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);

  Widget _buildProjects() => _buildTabContent([
    _customTextField('Project Title', 'projectTitle', controller: projectTitleController),
    _customTextField('Project Link', 'projectLink', controller: projectLinkController),

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
      'Summary about project',
      'projectSummary',
      maxLines: 7,
      controller: projectSummaryController,
    ),

    SizedBox(height: 20),


    gradientButton(
      text: "Next",
      onPressed: () {
        _saveData('projectTitle', projectTitleController.text);
        _saveData('projectLink', projectLinkController.text);
        _saveData('projectSummary', projectSummaryController.text);
        _saveData('projectStartDate', _projectStartDateController.text);
        _saveData('projectEndDate', _projectEndDateController.text);

        final formattedStartDate = formatDate(_projectStartDateController.text);
        final formattedEndDate = formatDate(_projectEndDateController.text);

        final projectFormatted = '${projectTitleController.text} '
            ' ${projectLinkController.text} '
            '$formattedStartDate - $formattedEndDate '
            '${projectSummaryController.text}';
        _saveData('project', projectFormatted);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);

  Widget _buildActivities() => _buildTabContent([
    _customTextField(
      'Feel free to share your personal activities and achievements that make you shine!',
      'activitiesAchievements',
      maxLines: 10,
      controller: activitiesController,
    ),

    SizedBox(height: 20),
    gradientButton(
      text: "Next",
      onPressed: () {
        _saveData('activities', activitiesController.text);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);

  Widget _buildInternship() => _buildTabContent([
    _customTextField('Organization Name', 'internshipOrganization', controller: internshipOrganizationController),
    _customTextField('Country', 'internshipCountry', controller: internshipCountryController),

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

    _customTextField(
      'Provide a brief description about internship',
      'internshipDescription',
      maxLines: 5,
      controller: internshipDescriptionController,
    ),

    SizedBox(height: 20),
    gradientButton(
      text: "Next",
      onPressed: () {
        _saveData('internshipOrganization', internshipOrganizationController.text);
        _saveData('internshipCountry', internshipCountryController.text);
        _saveData('internshipDescription', internshipDescriptionController.text);
        _saveData('internshipStartDate', _internshipStartDateController.text);
        _saveData('internshipEndDate', _internshipEndDateController.text);



        final formattedStartDate = formatDate(_internshipStartDateController.text);
        final formattedEndDate = formatDate(_internshipEndDateController.text);

        final internshipFormatted = '${internshipOrganizationController.text} '
            ' ${internshipCountryController.text} '
            '$formattedStartDate - $formattedEndDate '
            '${internshipDescriptionController.text}';
        _saveData('internship', internshipFormatted);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);

  Widget _buildExperience() => _buildTabContent([
    _customTextField('Job Title/Position', 'jobTitle', controller: jobTitleController),
    _customTextField('Company Name', 'companyName', controller: companyNameController),

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

    _customTextField(
      'Your Experience',
      'experienceDescription',
      maxLines: 5,
      controller: experienceDescriptionController,
    ),

    SizedBox(height: 20),
    gradientButton(
      text: "Next",
      onPressed: () {
        _saveData('jobTitle', jobTitleController.text);
        _saveData('companyName', companyNameController.text);
        _saveData('experienceDescription', experienceDescriptionController.text);
        _saveData('experienceStartDate', _experienceStartDateController.text);
        _saveData('experienceEndDate', _experienceEndDateController.text);

        final formattedStartDate = formatDate(_experienceStartDateController.text);
        final formattedEndDate = formatDate(_experienceEndDateController.text);

        final experienceFormatted = ' ${companyNameController.text} '
            '${jobTitleController.text} '
            '$formattedStartDate - $formattedEndDate '
            '${experienceDescriptionController.text}';
        _saveData('experience', experienceFormatted);
        _tabController.animateTo(_tabController.index + 1);
      },
    ),
  ]);

  Widget _buildLanguage() {
    return StatefulBuilder(
      builder: (context, setState) {
        if (selectedLanguages.isEmpty) {
          selectedLanguages.add('');
        }

        return _buildTabContent([
          ...selectedLanguages.asMap().entries.map((entry) {
            int index = entry.key;
            String value = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextFormField(
                initialValue: value,
                onChanged: (newValue) {
                  selectedLanguages[index] = newValue;
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., Language (B1, etc.)',
                  hintStyle: TextStyle(color: Colors.white38),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9860E4)),
                    borderRadius: BorderRadius.circular(10),
                  ),


                  suffixIcon: index == 0
                      ? IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.white),
                    onPressed: () => setState(() => selectedLanguages.add('')),
                  )
                      : IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.white30),
                    onPressed: () => setState(() => selectedLanguages.removeAt(index)),
                  ),
                ),
              ),
            );
          }).toList(),

          SizedBox(height: 20),

          gradientButton(
            text: "Next",
            onPressed: () {
              selectedLanguages.removeWhere((lang) => lang.trim().isEmpty);
              _saveData('languages', selectedLanguages.join(', '));
              _tabController.animateTo(_tabController.index + 1);
            },
          ),
        ]);
      },
    );
  }

  Widget _buildSkills() {
    return StatefulBuilder(
      builder: (context, setState) {
        final softController = TextEditingController();
        final techController = TextEditingController();

        Widget buildSkillSection(String hint, List<String> list, TextEditingController controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              TextField(
                controller: controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.white38),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9860E4)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.white),
                    onPressed: () {
                      final value = controller.text.trim();
                      if (value.isNotEmpty && !list.contains(value)) {
                        setState(() {
                          list.add(value);
                          controller.clear();
                        });
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty && !list.contains(value.trim())) {
                    setState(() {
                      list.add(value.trim());
                      controller.clear();
                    });
                  }
                },
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: list.map((skill) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              skill,
                              style: TextStyle(color: Color(0xFF9860E4), fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, size: 18, color: Colors.white),
                            onPressed: () => setState(() => list.remove(skill)),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
            ],
          );
        }

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSkillSection("Soft Skills (e.g., Communication)", selectedSoftSkills, softController),
              buildSkillSection("Technical Skills (e.g., Flutter)", selectedTechnicalSkills, techController),
              SizedBox(height: 20),
              gradientButton(
                text: "Next",
                onPressed: () {
                  _saveData('softSkills', selectedSoftSkills.join(', '));
                  _saveData('technicalSkills', selectedTechnicalSkills.join(', '));
                  _saveData('skills', [...selectedSoftSkills, ...selectedTechnicalSkills].join(', '));
                  _tabController.animateTo(_tabController.index + 1);
                },
              ),
            ],
          ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Full Name
                Text(
                  _getData('fullName'),
                  textAlign: TextAlign.center,  // Center the text
                  style: TextStyle(
                    fontFamily: 'Inter',  // Font family as requested
                    fontSize: 18,  // Font size as requested
                    fontWeight: FontWeight.w600,  // Font weight as requested
                    color: Color(0xFF000000),  // Color as requested
                    fontStyle: FontStyle.normal,  // Normal style
                  ),
                ),
                SizedBox(height: 4),

                // Contact Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,  // Center the row content
                  children: [
                    Text(
                      "P: ${_getData('phone')} | ${_getData('email')} | ${_getData('linkedin')} | ${_getData('github')}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                SizedBox(height: 16),

                // Summary
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Summary".toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),


                    Container(
                      color: Color(0xFF000000),
                      width: 348,
                      height: 0.5,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          " •  ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _getData('summary'),
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                SizedBox(height: 16),

                // Education

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title - "Summary" with the requested style
                    Text(
                      "Education".toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF000000),  // Color as requested
                        fontFamily: 'Inter',  // Font family as requested
                        fontSize: 12,  // Font size as requested
                        fontStyle: FontStyle.normal,  // Normal style
                        fontWeight: FontWeight.w700,  // Font weight as requested
                        height: 1.0,  // Line height as requested
                        letterSpacing: 0.5,  // Optional: To make it look slightly spaced out// Uppercase text
                      ),
                    ),
                    SizedBox(height: 4),

                    // Line Underneath with the requested styling
                    Container(
                      color: Color(0xFF000000),  // Background color (black)
                      width: 348,  // Width as requested
                      height: 0.5,  // Height as requested (line thickness)
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          " •  ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _getData('education'),
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                SizedBox(height: 16),

                // Project
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Project".toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),


                    Container(
                      color: Color(0xFF000000),
                      width: 348,
                      height: 0.5,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          " •  ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _getData('project'),
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                SizedBox(height: 16),

                // Activities
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Activities".toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),


                    Container(
                      color: Color(0xFF000000),
                      width: 348,
                      height: 0.5,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          " •  ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _getData('activities'),
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                SizedBox(height: 16),

                // Internship
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Internship".toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),


                    Container(
                      color: Color(0xFF000000),
                      width: 348,
                      height: 0.5,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          " •  ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _getData('internship'),
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                SizedBox(height: 16),

                // Experience
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Experience".toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),


                    Container(
                      color: Color(0xFF000000),
                      width: 348,
                      height: 0.5,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          " •  ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _getData('experience'),
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                SizedBox(height: 16),

                // Languages
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Languages".toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),


                    Container(
                      color: Color(0xFF000000),
                      width: 348,
                      height: 0.5,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getData('languages').split(', ').map((lang) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        "• $lang",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Skills
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skills".toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),


                    Container(
                      color: Color(0xFF000000),
                      width: 348,
                      height: 0.5,
                    ),
                  ],
                ),

                SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getData('skills').split(', ').map((skill) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        "• $skill",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    );
                  }).toList(),
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
      fontSize: 30,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );

    final sectionTitleStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );

    final normalTextStyle = pw.TextStyle(
      color: PdfColor.fromInt(0xFF000000),
      fontSize: 15,
      fontWeight: pw.FontWeight.normal,
      height: 1.4,
    );

    final smallTextStyle = const pw.TextStyle(fontSize: 15, color: PdfColors.black);

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

              pw.Center(
                child: pw.Text(
                  "P: ${_getData('phone')} | ${_getData('email')} | ${_getData('linkedin')} | ${_getData('github')}",
                  style: smallTextStyle,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 16),

              _buildSection("Summary", _getData('summary')),

              pw.Text(
                "Skills".toUpperCase(),
                style: _sectionHeaderStyle(),
              ),
              pw.Divider(),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (_getData('softSkills').isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Bullet(
                        text: "Soft Skills: ${_getData('softSkills')}",
                        style: pw.TextStyle(
                          fontSize: 15,
                          color: PdfColors.black,
                          height: 1.3,
                        ),
                        bulletSize: 4,
                        bulletColor: PdfColors.black,
                      ),
                    ),

                  if (_getData('technicalSkills').isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Bullet(
                        text:  "Technical Skills: ${_getData('technicalSkills')}",
                        style: pw.TextStyle(
                          fontSize: 15,
                          color: PdfColors.black,
                          height: 1.3,
                        ),
                        bulletSize: 4,
                        bulletColor: PdfColors.black,
                      ),
                    ),

                ],
              ),

              // Education Section (Customized Layout)
              pw.SizedBox(height: 16),
              _buildEducationRow("Education", _getData('education')),
              _buildExperienceRow("Experience", _getData('experience')),
              _buildInternshipRow("Internship", _getData('internship')),
              _buildProjectRow("Projects", _getData('project')),
              _buildSection("Activities", _getData('activities')),

              pw.SizedBox(height: 16),
              pw.Text(
                "Languages".toUpperCase(),
                style: _sectionHeaderStyle(),
              ),
              pw.Divider(),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: _getData('languages')
                    .split(', ')
                    .where((line) => line.trim().isNotEmpty)
                    .map((lang) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Bullet(
                    text: lang.trim(),
                    style: pw.TextStyle(
                      fontSize: 15,
                      color: PdfColors.black,
                      height: 1.4,
                    ),
                    bulletSize: 4,
                    bulletColor: PdfColors.black,

                  ),
                ))
                    .toList(),
              ),



            ],
          ),
        ],
      ),
    );

    final pdfBytes = await pdf.save();

    if (kIsWeb) {
      // Web implementation would go here, but we're removing it for mobile compatibility
      // You'll need to add a proper web implementation using a plugin like 'universal_html'
      // if you want to support web platform in the future
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Web platform is not supported in this version")),
      );
    } else {
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/cv.pdf");
      await file.writeAsBytes(pdfBytes);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saved to ${file.path}")),
      );

      // Offer to share the PDF file
      await Share.shareXFiles([XFile(file.path)], text: 'My CV');
    }
  }

  pw.Widget _buildProjectRow(String title, String content) {
    String formatDate(String inputDate) {
      try {
        final parsedDate = DateFormat('yyyy-MM-dd').parse(inputDate);
        return DateFormat('MMM yyyy').format(parsedDate);
      } catch (e) {
        return inputDate;
      }
    }

    final formattedStartDate = formatDate(_projectStartDateController.text);
    final formattedEndDate = formatDate(_projectEndDateController.text);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: _sectionHeaderStyle(),
        ),
        pw.Divider(),
        pw.SizedBox(height: 6),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20),
          child: pw.Wrap(
            spacing: 30,
            runSpacing: 10,
            children: [
              pw.Text(
                projectTitleController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                projectLinkController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                '$formattedStartDate - $formattedEndDate',
                style: pw.TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 12),

        pw.Bullet(
          text: projectSummaryController.text.trim(),
          style: pw.TextStyle(
            fontSize: 15,
            color: PdfColors.black,
            height: 1.4,
          ),
          bulletSize: 4,
          bulletColor: PdfColors.black,
        ),

        pw.SizedBox(height: 16),
      ],
    );
  }

  pw.Widget _buildInternshipRow(String title, String content) {

    String formatDate(String inputDate) {
      try {
        final parsedDate = DateFormat('yyyy-MM-dd').parse(inputDate);
        return DateFormat('MMM yyyy').format(parsedDate);
      } catch (e) {
        return inputDate;
      }
    }

    final formattedStartDate = formatDate(_internshipStartDateController.text);
    final formattedEndDate = formatDate(_internshipEndDateController.text);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: _sectionHeaderStyle(),
        ),
        pw.Divider(),
        pw.SizedBox(height: 6),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20),
          child: pw.Wrap(
            spacing: 60,
            runSpacing: 10,

            children: [
              pw.Text(
                internshipOrganizationController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                internshipCountryController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                '$formattedStartDate - $formattedEndDate',
                style: pw.TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),



        pw.SizedBox(height: 12),

        pw.Bullet(
          text: internshipDescriptionController.text.trim(),
          style: pw.TextStyle(
            fontSize: 15,
            color: PdfColors.black,
            height: 1.4,
          ),
          bulletSize: 4,
          bulletColor: PdfColors.black,
        ),


        pw.SizedBox(height: 16),
      ],
    );

  }

  pw.Widget _buildExperienceRow(String title, String content) {

    String formatDate(String inputDate) {
      try {
        final parsedDate = DateFormat('yyyy-MM-dd').parse(inputDate);
        return DateFormat('MMM yyyy').format(parsedDate);
      } catch (e) {
        return inputDate;
      }
    }

    final formattedStartDate = formatDate(_experienceStartDateController.text);
    final formattedEndDate = formatDate(_experienceEndDateController.text);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: _sectionHeaderStyle(),
        ),
        pw.Divider(),
        pw.SizedBox(height: 6),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20),
          child: pw.Wrap(
            spacing: 60,
            runSpacing: 10,
            children: [
              pw.Text(
                companyNameController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                jobTitleController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                '$formattedStartDate - $formattedEndDate',
                style: pw.TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),



        pw.SizedBox(height: 12),

        pw.Bullet(
          text: experienceDescriptionController.text.trim(),
          style: pw.TextStyle(
            fontSize: 15,
            color: PdfColors.black,
            height: 1.4,
          ),
          bulletSize: 4,
          bulletColor: PdfColors.black,
        ),


        pw.SizedBox(height: 16),
      ],
    );

  }

  pw.Widget _buildEducationRow(String title, String content) {

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: _sectionHeaderStyle(),
        ),
        pw.Divider(),
        pw.SizedBox(height: 6),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20),
          child: pw.Wrap(
            spacing: 30,
            runSpacing: 10,
            children: [
              pw.Text(
                universityNameController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                degreeNameController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                educationCountryController.text.trim(),
                style: pw.TextStyle(fontSize: 15),
              ),
              pw.Text(
                'GPA: ${gpaController.text.trim()}',
                style: pw.TextStyle(fontSize: 15),
              ),



            ],
          ),
        ),
        pw.SizedBox(height: 16),
      ],
    );

  }

  pw.TextStyle _sectionHeaderStyle() {
    return pw.TextStyle(
      color: PdfColors.black,
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      height: 1.0,
      letterSpacing: 0.5,
    );
  }

  pw.Widget _buildSection(String title, String data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: _sectionHeaderStyle(),
        ),
        pw.Divider(),
        ...data.split('\n').map(
              (line) => pw.Bullet(
            text: line.trim(),
            style: pw.TextStyle(
              fontSize: 15,
              color: PdfColors.black,
              height: 1.4,
            ),
            bulletSize: 4, // حجم النقطة
            bulletColor: PdfColors.black,
          ),
        ),
        pw.SizedBox(height: 16),
      ],
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
