// ignore_for_file: avoid_print, deprecated_member_use, unused_element, unused_field

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Added for text-to-speech
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants/constants.dart';
import '../utils/background_decorations.dart';
import '../models/interview_model.dart';
import '../services/fixed_api_service.dart';
import 'score_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/history_service.dart';
import '../models/history_model.dart';
import '../widgets/gradient_button.dart';

class InterviewScreen extends StatefulWidget {
  final String field;
  final List<String> technologies;
  final String difficulty;

  const InterviewScreen({
    super.key,
    required this.field,
    required this.technologies,
    required this.difficulty,
  });

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen>
    with SingleTickerProviderStateMixin {
  int seconds = 59;
  int minutes =
      1; // Changed to 2 minutes per question (initialized as 1 minute)
  late Timer timer;
  late AnimationController _waveformController;
  late Animation<double> _waveformAnimation;
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  List<double> _waveformData = List.generate(12, (index) => 0.0);
  Timer? _waveformTimer;
  bool _isTimeUp = false;

  // Text to speech
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  // Interview state
  InterviewModel? _interviewModel;
  bool _isLoading = true;
  String? _currentRecordingPath;
  bool _isEvaluating = false;
  String _statusMessage = 'Loading questions...';
  bool _hasError = false;

  // Add new variables for AssemblyAI
  static const String _assemblyAiApiKey = 'f215bd2071b44a1586075e12c725c15f';
  static const String _assemblyAiBaseUrl = 'https://api.assemblyai.com/v2';
  Timer? _transcriptionPollingTimer;
  String? _currentTranscriptionId;
  bool _isListening = false;
  String _transcribedText = '';

  final bool _isButtonLoading = false;
  Timer? _loadingTimeoutTimer;
  DateTime? _lastRecordTap;

  @override
  void initState() {
    super.initState();
    _initializeAudioRecorder();
    _initWaveformAnimation();
    _setupTextToSpeech();
    _requestPermissions();
    _loadInterviewQuestions();
    _loadingTimeoutTimer = Timer(const Duration(seconds: 15), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _statusMessage =
              'Loading timed out. Please check your connection and try again.';
        });
      }
    });
  }

  Future<void> _initializeAudioRecorder() async {
    try {
      // Check if microphone is available
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        print('Microphone permission not granted');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission is required for recording'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      print('Audio recorder initialized successfully');
    } catch (e) {
      print('Error initializing audio recorder: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing audio recorder: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Setup text to speech with male voice
  Future<void> _setupTextToSpeech() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(0.8);
    await _flutterTts.setPitch(0.9); // Lower pitch for male voice

    // Set up completion listener
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  // Speak text with TTS
  Future<void> _speakQuestion(String question) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
      return;
    }

    setState(() {
      _isSpeaking = true;
    });

    await _flutterTts.speak(question);
  }

  // Request permissions
  Future<void> _requestPermissions() async {
    try {
      // Request microphone permission first
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Microphone permission is required for speech recognition',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Then request storage permission
      final storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Storage permission is required for saving recordings',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Initialize speech recognition after permissions are granted
      await _startListening();
    } catch (e) {
      print('Error requesting permissions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error requesting permissions: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Load interview questions from API
  Future<void> _loadInterviewQuestions() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Loading questions...';
      _hasError = false;
    });
    try {
      List<String> questions;
      if (kIsWeb) {
        questions = [
          "What are your primary strengths in ${widget.field} development?",
          "Describe a challenging project you worked on with ${widget.technologies.join(', ')}.",
          "How do you approach debugging issues in your code?",
          "What development methodologies are you familiar with?",
          "How do you stay updated with the latest technologies in your field?",
        ];
      } else {
        questions = await FixedApiService.generateInterviewQuestions(
          field: widget.field,
          technologies: widget.technologies,
          difficulty: widget.difficulty,
        );
      }
      final interviewQuestions =
          questions.map((q) => InterviewQuestion(question: q)).toList();
      if (!mounted) return;
      setState(() {
        _interviewModel = InterviewModel(
          field: widget.field,
          technologies: widget.technologies,
          difficulty: widget.difficulty,
          questions: interviewQuestions,
        );
        _isLoading = false;
        _hasError = false;
        startTimer();
        if (interviewQuestions.isNotEmpty) {
          _speakQuestion(interviewQuestions[0].question);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _statusMessage = 'Error loading questions: $e';
      });
    } finally {
      _loadingTimeoutTimer?.cancel();
    }
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

  Future<String> _getAudioFilePath() async {
    // For Android, use the external storage directory
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('Could not access external storage');
    }

    final recordingsDir = Directory('${directory.path}/recordings');
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    return '${recordingsDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  // Start listening for speech
  Future<void> _startListening() async {
    if (!_isListening) {
      try {
        // Check microphone permission first
        final micStatus = await Permission.microphone.status;
        if (!micStatus.isGranted) {
          final result = await Permission.microphone.request();
          if (!result.isGranted) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Microphone permission is required for speech recognition',
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            }
            return;
          }
        }

        setState(() {
          _isListening = true;
          _transcribedText = '';
        });

        // Start polling for transcription results
        _startTranscriptionPolling();
      } catch (e) {
        print('Speech recognition error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please try speaking again'),
              duration: Duration(seconds: 2),
            ),
          );
          setState(() {
            _isListening = false;
          });
        }
      }
    }
  }

  // Stop listening for speech
  Future<void> _stopListening() async {
    if (_isListening) {
      try {
        _transcriptionPollingTimer?.cancel();
        setState(() {
          _isListening = false;
        });
      } catch (e) {
        print('Error stopping speech recognition: $e');
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  // Start polling for transcription results
  void _startTranscriptionPolling() {
    _transcriptionPollingTimer?.cancel();
    _transcriptionPollingTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      if (!_isListening) {
        timer.cancel();
        return;
      }

      try {
        if (_currentTranscriptionId != null) {
          final response = await http.get(
            Uri.parse(
              '$_assemblyAiBaseUrl/transcript/$_currentTranscriptionId',
            ),
            headers: {'authorization': _assemblyAiApiKey},
          );

          if (response.statusCode == 200) {
            final result = json.decode(response.body);
            if (result['status'] == 'completed') {
              setState(() {
                _transcribedText = result['text'] ?? '';
              });
              timer.cancel();
            } else if (result['status'] == 'error') {
              print('Transcription error: ${result['error']}');
              timer.cancel();
            }
          }
        }
      } catch (e) {
        print('Error polling transcription: $e');
      }
    });
  }

  // Start recording audio
  Future<void> _startRecording() async {
    try {
      // Check microphone permission first
      final micStatus = await Permission.microphone.status;
      if (!micStatus.isGranted) {
        final result = await Permission.microphone.request();
        if (!result.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Microphone permission is required for recording',
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }

      // Check if microphone is available
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission is required for recording'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/recordings';
      await Directory(path).create(recursive: true);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$path/recording_$timestamp.aac';

      print('Starting recording to: $filePath');

      // Configure audio recording
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: filePath,
      );

      setState(() {
        _isRecording = true;
        _currentRecordingPath = filePath;
      });

      // Start speech recognition after recording starts
      await _startListening();
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting recording: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Stop recording audio
  Future<void> _stopRecording() async {
    try {
      if (_isRecording) {
        print('Stopping recording...');
        await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
        });
        print('Recording saved to: $_currentRecordingPath');

        // Upload the recording to AssemblyAI
        if (_currentRecordingPath != null) {
          final file = File(_currentRecordingPath!);
          if (!await file.exists()) {
            print(
              'Error: Recording file does not exist at $_currentRecordingPath',
            );
            return;
          }

          print('Reading recording file...');
          final bytes = await file.readAsBytes();
          print('File size: ${bytes.length} bytes');

          print('Uploading to AssemblyAI...');
          final uploadResponse = await http.post(
            Uri.parse('$_assemblyAiBaseUrl/upload'),
            headers: {'authorization': _assemblyAiApiKey},
            body: bytes,
          );

          if (uploadResponse.statusCode == 200) {
            final uploadResult = json.decode(uploadResponse.body);
            final audioUrl = uploadResult['upload_url'];
            print('Upload successful. Audio URL: $audioUrl');

            // Start transcription
            print('Starting transcription...');
            final transcriptionResponse = await http.post(
              Uri.parse('$_assemblyAiBaseUrl/transcript'),
              headers: {
                'authorization': _assemblyAiApiKey,
                'content-type': 'application/json',
              },
              body: json.encode({
                'audio_url': audioUrl,
                'speech_model': 'universal',
              }),
            );

            if (transcriptionResponse.statusCode == 200) {
              final transcriptionResult = json.decode(
                transcriptionResponse.body,
              );
              _currentTranscriptionId = transcriptionResult['id'];
              print('Transcription started. ID: $_currentTranscriptionId');

              // Wait for transcription to complete
              bool isCompleted = false;
              while (!isCompleted) {
                await Future.delayed(const Duration(seconds: 2));
                final statusResponse = await http.get(
                  Uri.parse(
                    '$_assemblyAiBaseUrl/transcript/$_currentTranscriptionId',
                  ),
                  headers: {'authorization': _assemblyAiApiKey},
                );

                if (statusResponse.statusCode == 200) {
                  final statusResult = json.decode(statusResponse.body);
                  if (statusResult['status'] == 'completed') {
                    setState(() {
                      _transcribedText = statusResult['text'] ?? '';
                    });
                    isCompleted = true;

                    // Evaluate the answer after transcription is complete
                    await _evaluateAnswer(_currentRecordingPath!);
                  } else if (statusResult['status'] == 'error') {
                    print('Transcription error: ${statusResult['error']}');
                    break;
                  }
                }
              }
            } else {
              print(
                'Error starting transcription: ${transcriptionResponse.body}',
              );
            }
          } else {
            print('Error uploading file: ${uploadResponse.body}');
          }
        }
      }
    } catch (e) {
      print('Error stopping recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error stopping recording: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Evaluate the recorded answer
  Future<void> _evaluateAnswer(String audioPath) async {
    if (_interviewModel == null) return;

    setState(() {
      _isEvaluating = true;
      _statusMessage = 'Evaluating your answer...';
    });

    try {
      // Use the transcribed text instead of placeholder
      final transcribedAnswer =
          _transcribedText.isNotEmpty
              ? _transcribedText
              : "No speech was detected. Please try recording your answer again.";

      // Save the answer to the current question
      _interviewModel!.currentQuestion.answer = transcribedAnswer;

      // Evaluate the answer using the API
      final evaluation = await FixedApiService.evaluateAnswer(
        question: _interviewModel!.currentQuestion.question,
        answer: transcribedAnswer,
        field: widget.field,
        technologies: widget.technologies,
        difficulty: widget.difficulty,
      );

      // Update the question with the evaluation results
      setState(() {
        _interviewModel!.currentQuestion.score = evaluation['score'];
        _interviewModel!.currentQuestion.feedback = evaluation['feedback'];
        _isEvaluating = false;
        _transcribedText = ''; // Reset transcribed text
      });
    } catch (e) {
      setState(() {
        _isEvaluating = false;
        _statusMessage = 'Error evaluating answer: $e';
      });
    }
  }

  // Skip the current question
  void _skipQuestion() {
    if (_interviewModel == null) return;

    // If recording, stop it first
    if (_isRecording) {
      _stopRecording();
      return;
    }

    // Stop TTS if it's speaking
    if (_isSpeaking) {
      _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    }

    if (_interviewModel!.hasNextQuestion) {
      _nextQuestion();
    } else {
      _finishInterview();
    }
  }

  // Move to the next question or finish the interview
  void _nextQuestion() {
    if (_interviewModel == null) return;

    // Stop TTS if it's speaking
    if (_isSpeaking) {
      _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    }

    if (_interviewModel!.hasNextQuestion) {
      setState(() {
        _interviewModel!.nextQuestion();
        // Reset timer for the new question
        minutes = 1;
        seconds = 59;
        _isTimeUp = false;
        _transcribedText = ''; // Clear transcribed text
        _currentRecordingPath = null; // Clear recording path

        // Speak the new question
        _speakQuestion(_interviewModel!.currentQuestion.question);
      });
      // Restart the timer for the new question
      timer.cancel(); // Cancel the old timer
      startTimer(); // Start a new timer
    } else {
      _finishInterview();
    }
  }

  // Finish the interview and navigate to the score screen
  Future<void> _finishInterview() async {
    if (_interviewModel == null) return;

    // Stop TTS if it's speaking
    if (_isSpeaking) {
      await _flutterTts.stop();
    }

    setState(() {
      _interviewModel!.isCompleted = true;
    });

    // Save interview to history
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyService = HistoryService(prefs);

      // Calculate total score
      final totalScore =
          _interviewModel!.questions.fold<int>(
            0,
            (sum, question) => sum + (question.score ?? 0),
          ) ~/
          _interviewModel!.questions.length;

      // Create interview history
      final interviewHistory = InterviewHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        field: widget.field,
        technologies: widget.technologies,
        difficulty: widget.difficulty,
        date: DateTime.now(),
        totalScore: totalScore,
        questions:
            _interviewModel!.questions
                .map(
                  (q) => QuestionHistory(
                    question: q.question,
                    answer: q.answer ?? '',
                    score: q.score ?? 0,
                    feedback: q.feedback ?? '',
                  ),
                )
                .toList(),
      );

      // Save to history
      await historyService.saveInterview(interviewHistory);
    } catch (e) {
      print('Error saving interview history: $e');
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreScreen(interviewModel: _interviewModel!),
      ),
    );
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
    _flutterTts.stop();
    _flutterTts.setCompletionHandler(() {});
    _transcriptionPollingTimer?.cancel();
    _loadingTimeoutTimer?.cancel();
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

            // Auto-skip when time is up
            if (!_isEvaluating && _interviewModel != null) {
              // If recording was in progress, stop it first
              if (_isRecording) {
                _stopRecording();
              } else {
                // Skip to next question
                _skipQuestion();
              }
            }
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
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const BackgroundDecorations(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child:
                _isLoading
                    ? Center(
                      key: const ValueKey('loading'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.primaryPurple,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _statusMessage,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                    : _hasError
                    ? Center(
                      key: const ValueKey('error'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _statusMessage,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadInterviewQuestions,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                    : _interviewModel != null
                    ? SafeArea(
                      key: const ValueKey('content'),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timer and progress indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Question progress
                                Text(
                                  'Question ${_interviewModel!.currentQuestionIndex + 1}/${_interviewModel!.questions.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Timer
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _isTimeUp
                                            ? Colors.red
                                            : AppColors.darkPurple,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Question card
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Question
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.darkPurple,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Question:',
                                                style: TextStyle(
                                                  color:
                                                      AppColors.primaryPurple,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // Text-to-speech toggle button
                                              IconButton(
                                                onPressed: () {
                                                  _speakQuestion(
                                                    _interviewModel!
                                                        .currentQuestion
                                                        .question,
                                                  );
                                                },
                                                icon: Icon(
                                                  _isSpeaking
                                                      ? Icons.volume_off
                                                      : Icons.volume_up,
                                                  color: Colors.white,
                                                ),
                                                tooltip:
                                                    _isSpeaking
                                                        ? 'Stop Speaking'
                                                        : 'Speak Question',
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _interviewModel!
                                                .currentQuestion
                                                .question,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Answer display
                                    Card(
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Your Answer:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                _transcribedText.isEmpty
                                                    ? 'Your answer will appear here...'
                                                    : _transcribedText,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      _transcribedText.isEmpty
                                                          ? Colors.grey[600]
                                                          : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Evaluation results if available
                                    if (_interviewModel!
                                            .currentQuestion
                                            .score !=
                                        null) ...[
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.darkPurple,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primaryPurple,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Evaluation:',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryPurple,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: _getScoreColor(
                                                      _interviewModel!
                                                          .currentQuestion
                                                          .score!,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Score: ${_interviewModel!.currentQuestion.score}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              _interviewModel!
                                                      .currentQuestion
                                                      .feedback ??
                                                  '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ],
                                ),
                              ),
                            ),

                            // Recording status and controls
                            if (_isEvaluating) ...[
                              Center(
                                child: Column(
                                  children: [
                                    const CircularProgressIndicator(
                                      color: AppColors.primaryPurple,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _statusMessage,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              // Waveform visualization
                              if (_isRecording) ...[
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkPurple,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(
                                      _waveformData.length,
                                      (index) => AnimatedBuilder(
                                        animation: _waveformAnimation,
                                        builder: (context, child) {
                                          return Container(
                                            width: 4,
                                            height:
                                                10 +
                                                (_waveformData[index] * 40),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryPurple,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Action buttons
                              if (!kIsWeb) ...[
                                const SizedBox(
                                  height: 0,
                                ), // Adjusted spacing before action buttons to move button up
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (_interviewModel!
                                            .currentQuestion
                                            .score !=
                                        null) ...[
                                      Expanded(
                                        child: GradientButton(
                                          text:
                                              _interviewModel!.hasNextQuestion
                                                  ? 'Next Question'
                                                  : 'Finish Interview',
                                          height: 75,
                                          icon: Icons.navigate_next,
                                          isLoading: _isButtonLoading,
                                          onPressed:
                                              _isButtonLoading
                                                  ? null
                                                  : _nextQuestion,
                                        ),
                                      ),
                                    ] else ...[
                                      Expanded(
                                        child: GradientButton(
                                          text:
                                              _isRecording
                                                  ? 'Stop Recording'
                                                  : 'Start Recording',
                                          height: 75,
                                          icon:
                                              _isRecording
                                                  ? Icons.stop
                                                  : Icons.mic,
                                          dynamicBackgroundColor:
                                              _isRecording ? Colors.red : null,
                                          isLoading: _isButtonLoading,
                                          onPressed:
                                              _isButtonLoading
                                                  ? null
                                                  : (_isRecording
                                                      ? _stopRecording
                                                      : _startRecording),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed:
                                              _isButtonLoading
                                                  ? null
                                                  : _skipQuestion,
                                          icon: const Icon(
                                            Icons.skip_next,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            'Skip Question',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.darkPurple,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // Helper function to get color based on score
  Color _getScoreColor(int score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 50) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }
}
