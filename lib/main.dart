// ignore_for_file: public_member_api_docs, sort_constructors_first
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:road_map_mentor/core/features/cv_analysis/database/hive/models/preferred/preferred_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/constants/hive_constants.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/history/chat_session_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/preferred/preferred_messages_model.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:road_map_mentor/core/features/splash/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive first
    await Hive.initFlutter();

    // Register the adapters for your models
    Hive.registerAdapter(PreferredMessagesModelAdapter());
    Hive.registerAdapter(ChatSessionModelAdapter());
    Hive.registerAdapter(PreferredAnalyzeResumeMessagesModelAdapter());

    // Open the boxes
    await Hive.openBox<PreferredMessagesModel>(kPreferredMessages);
    await Hive.openBox<PreferredAnalyzeResumeMessagesModel>(kAnalyzeResumePreferredMessages);
    await Hive.openBox<ChatSessionModel>(kChatSessions);

    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize Firebase with proper error handling
    await Firebase.initializeApp(
        // Uncomment and use this if you have firebase_options.dart
        // options: DefaultFirebaseOptions.currentPlatform,
        );

    // Add a small delay to ensure Firebase is fully initialized
    await Future.delayed(const Duration(milliseconds: 100));

    runApp(const MyApp());
  } catch (e) {
    // Log the error for debugging
    debugPrint('Initialization error: $e');

    // Run app with error handling
    runApp(MyAppWithError(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Road Map Mentor',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF110A2B),
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// Wrapper to ensure Firebase is properly initialized before showing main screen
class FirebaseInitWrapper extends StatelessWidget {
  const FirebaseInitWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Double-check Firebase initialization
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF110A2B),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Firebase Initialization Error',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Restart the app
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const SpScreen(); // Changed to start with splash screen
        }

        // Show loading screen while initializing
        return const Scaffold(
          backgroundColor: Color(0xFF110A2B),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                ),
                SizedBox(height: 16),
                Text(
                  'Initializing Firebase...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _initializeFirebase() async {
    // Add a small delay to ensure all services are ready
    await Future.delayed(const Duration(milliseconds: 200));

    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          // Uncomment if you have firebase_options.dart
          // options: DefaultFirebaseOptions.currentPlatform,
          );
    }

    // Additional delay for Firebase Auth to be ready
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

// Error handling app widget
class MyAppWithError extends StatelessWidget {
  final String error;

  const MyAppWithError({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Road Map Mentor',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF110A2B),
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
