// ignore_for_file: public_member_api_docs, sort_constructors_first
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/constants/hive_constants.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/preferred/preferred_messages_model.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';

void main() async {
  ///Initialize [Hive]
  await Hive.initFlutter();
  Hive.registerAdapter(PreferredMessagesModelAdapter());
  await Hive.openBox<PreferredMessagesModel>(kPreferredMessages);

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HydratedBloc storage
  final storage = await getTemporaryDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(storage.path),
  );

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
