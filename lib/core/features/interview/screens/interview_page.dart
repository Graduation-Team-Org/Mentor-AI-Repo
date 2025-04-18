import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';


class InterviewPage extends StatelessWidget {
  const InterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF110A2B),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.3,
            left: screenWidth * 0.15,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF352250),
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
                  color: const Color(0xFF9860E4),
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
                  color: const Color(0xFF9860E4),
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
                    color: const Color(0xFF40174C)
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button and header
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Centered Welcome text
                        Text(
                          'Welcome! 🎉',
                          style: TextStyle(
                            color: const Color(0xFFF5EFFC),
                            fontSize: 30,
                            fontFamily: 'Inter',
                            height: 1.40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Back button in the top left
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Introduction text
                    Text(
                      'Congratulations on reaching this stage! Before you start the interview, there are just two simple steps:',
                      style: TextStyle(
                        color: Color(0xFFF5EFFC),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        height: 1.40,
                      ),

                    ),
                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(0xFF9860E4),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Select the field you want to be interviewed in.',
                            style: TextStyle(
                              color: Color(0xFFF5EFFC),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              height: 1.40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(0xFF9860E4),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Choose your level to get questions that match your experience.',
                            style: TextStyle(
                              color: Color(0xFFF5EFFC),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              height: 1.40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Additional info
                    Text(
                      'Once you press "Start", you\'ll meet David, who will conduct your interview.',
                      style: TextStyle(
                        color: Color(0xFFF5EFFC),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        height: 1.40,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Interview Details:',
                      style: TextStyle(
                        color: Color(0xFF9860E4),
                        fontSize: 20,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Number of questions:',
                            style: TextStyle(
                              color: const Color(0xFF9860E4),
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '6',
                            style: TextStyle(
                              color: const Color(0xFFF5EFFC),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              height: 1.40,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Duration:',
                            style: TextStyle(
                              color: const Color(0xFF9860E4),
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '45 minutes',
                            style: TextStyle(
                              color: const Color(0xFFF5EFFC),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              height: 1.40,
                            ),
                          ),
                        ],
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          height: 1.40,
                        ),
                        children: [
                          TextSpan(
                            text: 'Time limit:  ',
                            style: TextStyle(
                              color: const Color(0xFF9860E4),

                            ),
                          ),

                          TextSpan(
                            text: 'Once the time is up, you won\'t be able to continue. Press "Finish" to see your score, weaknesses, and recommendations to improve.',
                            style: TextStyle(
                              color: const Color(0xFFF5EFFC),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // GO button
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7A4DB6),
                              Color(0xFFDFCEF7),
                              Color(0xFFF0E7FB),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FieldSelectionPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          child: const Text(
                            "GO",
                            style: TextStyle(
                              color: Color(0xFF352250),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FieldSelectionPage extends StatefulWidget {
  const FieldSelectionPage({super.key});

  @override
  State<FieldSelectionPage> createState() => _FieldSelectionPageState();
}

class _FieldSelectionPageState extends State<FieldSelectionPage> {
  String? selectedField;
  List<String> selectedTechnologies = [];
  String? selectedDifficulty;

  final Map<String, List<String>> fieldTechnologies = {
    'Frontend': ['React', 'Angular', 'Vue.js', 'Svelte'],
    'Backend': ['Node.js', 'Python', 'Java', 'PHP', 'Ruby'],
    'Mobile': ['Flutter', 'React Native', 'Swift', 'Kotlin'],
    'Devops': [
      'Linux',
      'Docker',
      'Kubernetes',
      'Terraform',
      'AWS',
      'Azure',
      'CI/CD',
      'Monitoring',
    ],
    'UI/UX Design': ['Figma', 'Adobe XD', 'Sketch'],
    'Data Analysis': ['Python', 'R', 'SQL', 'Tableau'],
    'Data Science': ['Python', 'R', 'TensorFlow', 'PyTorch'],
    'Cyber Security': [
      'Network Security',
      'Application Security',
      'Cloud Security',
    ],
  };

  // Tracks that allow multiple technology selections
  final Set<String> multiSelectTracks = {
    'Devops',
    'Cyber Security',
    'Data Analysis',
    'Data Science',
  };

  final List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];

  bool get isMultiSelect =>
      selectedField != null && multiSelectTracks.contains(selectedField);

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
                    color: Color(0xFF40174C)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("image/home4.png"),
              ),
              // Back button and avatar
              const SizedBox(height: 16),

              // Instruction text
              const Text(
                "Choose the field and determine the level.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFF5EFFC),
                ),
              ),
              const SizedBox(height: 24),

              // Field selection
              const Text(
                'Select Track:',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFFF5EFFC),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                fieldTechnologies.keys.map((field) {
                  return ChoiceChip(
                    label: Text(field),
                    selected: selectedField == field,
                    onSelected: (selected) {
                      setState(() {
                        selectedField = selected ? field : null;
                        selectedTechnologies.clear();
                        selectedDifficulty = null;
                      });
                    },
                    backgroundColor: Color(0xFF352250),
                    selectedColor: Colors.purple[400],
                    labelStyle: TextStyle(
                      color:
                      selectedField == field
                          ? Colors.white
                          : Colors.white70,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              if (selectedField != null) ...[
                Text(
                  'Select Technology${isMultiSelect ? ' (Multiple allowed)' : ''}:',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                  fieldTechnologies[selectedField]!.map((tech) {
                    return ChoiceChip(
                      label: Text(tech),
                      selected: selectedTechnologies.contains(tech),
                      onSelected: (selected) {
                        setState(() {
                          if (isMultiSelect) {
                            if (selected) {
                              selectedTechnologies.add(tech);
                            } else {
                              selectedTechnologies.remove(tech);
                            }
                          } else {
                            selectedTechnologies = selected ? [tech] : [];
                          }
                          if (selectedTechnologies.isEmpty) {
                            selectedDifficulty = null;
                          }
                        });
                      },
                      backgroundColor: Color(0xFF352250),
                      selectedColor: Colors.purple[400],
                      labelStyle: TextStyle(
                        color:
                        selectedTechnologies.contains(tech)
                            ? Colors.white
                            : Colors.white70,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              if (selectedTechnologies.isNotEmpty) ...[
                const Text(
                  'Select Difficulty:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                  difficulties.map((difficulty) {
                    return ChoiceChip(
                      label: Text(difficulty),
                      selected: selectedDifficulty == difficulty,
                      onSelected: (selected) {
                        setState(() {
                          selectedDifficulty =
                          selected ? difficulty : null;
                        });
                      },
                      backgroundColor: Color(0xFF352250),
                      selectedColor: Colors.purple[400],
                      labelStyle: TextStyle(
                        color:
                        selectedDifficulty == difficulty
                            ? Colors.white
                            : Colors.white70,
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedField != null &&
                      selectedTechnologies.isNotEmpty &&
                      selectedDifficulty != null
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InterviewScreen()),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7A4DB6),
                          Color(0xFFDFCEF7),
                          Color(0xFFF0E7FB),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Start",
                        style: TextStyle(
                          color: Color(0xFF352250),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }
}

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}



class _InterviewScreenState extends State<InterviewScreen>
    with SingleTickerProviderStateMixin {
  int seconds = 58;
  int minutes = 0;
  late Timer timer;
  late AnimationController _waveformController;
  late Animation<double> _waveformAnimation;
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  List<double> _waveformData = List.generate(12, (index) => 0.0);
  Timer? _waveformTimer;
  bool _isTimeUp = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    _initWaveformAnimation();
    _requestMicrophonePermission();
  }

  void _initWaveformAnimation() {
    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _waveformAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveformController, curve: Curves.easeInOut),
    );

    _waveformController.repeat(reverse: true);
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is required')),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.isGranted) {
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: '${DateTime.now().millisecondsSinceEpoch}.aac',
        );
        setState(() {
          _isRecording = true;
        });
        _startWaveformUpdate();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error starting recording: $e')));
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      _stopWaveformUpdate();
      print('Recording saved to: $path');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error stopping recording: $e')));
      }
    }
  }

  void _startWaveformUpdate() {
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _waveformData = List.generate(12, (index) {
          // Simulate audio levels with random values
          return (0.2 +
              (0.8 * (index % 3) / 2) +
              (0.2 * _waveformAnimation.value));
        });
      });
    });
  }

  void _stopWaveformUpdate() {
    _waveformTimer?.cancel();
    setState(() {
      _waveformData = List.generate(12, (index) => 0.0);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _waveformController.dispose();
    _waveformTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
            timer.cancel();
            _isTimeUp = true;
          }
        }
      });
    });
  }

  String formatTime() {
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
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
                    color: Color(0xFF40174C)
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Timer at the top
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16, right: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF669B).withAlpha(51),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      formatTime(),
                      style: const TextStyle(
                        color: Color(0xFF9747FF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Interviewer avatar
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[400],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'image/home4.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),

                // Audio waveform visualization
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      12,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 4,
                        height: _waveformData[index] * 30,
                        decoration: BoxDecoration(
                          color:
                          _isRecording
                              ?  Color(0xFF9747FF)
                              :  Color(0xFF9747FF).withAlpha(128,),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),

                // Question text
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Lorem ipsum dolor sit amet consectetur. Pellentesque lorem dui augue libero pulvinar nullam mattis. Nullam vitae sem nisl at dolor a platea nec. Euismod risus vitae elementum vitae leo bibendum ac luctus mattis. Laoreet sit rhoncus magna tristique?',
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                if (_isTimeUp) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Finish',
                      style: TextStyle(
                        color: Color(0xFF9747FF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScoreScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white24,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: const BorderSide(color: Colors.white, width: 1),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Click to see the score',
                        style: TextStyle(
                          color: Color(0xFF9747FF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: GestureDetector(
                      onTap: () {
                        if (_isRecording) {
                          _stopRecording();
                        } else {
                          _startRecording();
                        }
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRecording ?  Color(0xFFFF669B) : Color(0xFF9747FF),
                          boxShadow: [
                            BoxShadow(
                              color: (_isRecording
                                  ? Color(0xFFFF669B)
                                  : Color(0xFF9747FF)),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ScoreScreen extends StatelessWidget {
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
                    color: Color(0xFF40174C)
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Back button at the top
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                // Text showing Score
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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