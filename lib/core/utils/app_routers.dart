import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/get_all_preferred_mesages_cubit/get_all_preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/chat_message_screen.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/preferred_messages_screen.dart';
import 'package:road_map_mentor/core/features/splash/presentation/screens/splash_screen.dart';
import 'package:road_map_mentor/core/features/starting/presentation/screens/starting_screen.dart';

abstract class AppRouter {
  static final _roadMapRepos = RoadMapReposImp();

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SpScreen(),
      ),
      GoRoute(
        path: startingScreen,
        builder: (context, state) =>  StartingScreen(),
      ),
      GoRoute(
        path: preferredMessagesScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => GetAllPreferredMessagesCubit(),
          child: const PreferredMessagesScreen(),
        ),
      ),
      GoRoute(
        path: chatScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => AllMessagesCubit(_roadMapRepos),
          child: const ChatScreen(),
        ),
      ),
      // GoRoute(
      //   path: '$savedAllMessagesScreen/:title', // Update path pattern
      //   builder: (context, state) => BlocProvider(
      //     create: (context) => SavedAllMessagesCubit(_roadMapRepos),
      //     child: SavedAllMessagesScreen(
      //       title: state.pathParameters['title']!,
      //     ),
      //   ),
      // ),
    ],
  );
  static const String savedAllMessagesScreen = '/saved'; // Base path
  static const String preferredMessagesScreen =
      '/preferredMessagesScreen'; // Base path
  static const String chatScreen = '/chatScreen'; // Base path
  static const String startingScreen = '/startingScreen'; // Base path
}
