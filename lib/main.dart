// ignore_for_file: public_member_api_docs, sort_constructors_first
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/constants/hive_constants.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/preferred_messages_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register the adapter for your model
  Hive.registerAdapter(PreferredMessagesModelAdapter());
  
  // Open the box
  await Hive.openBox<PreferredMessagesModel>(kPreferredMessages);
  
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
//asst_vA6qUxFYUi6AJiKJGBKPjzKE
