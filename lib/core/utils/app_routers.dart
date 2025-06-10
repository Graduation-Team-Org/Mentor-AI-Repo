import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/default_home/screens/default_home_page.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/get_all_preferred_mesages_cubit/get_all_preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/preferred_messages_cubit/preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/chat_message_screen.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/preferred_messages_screen.dart';
import 'package:road_map_mentor/core/features/splash/presentation/screens/splash_screen.dart';
import 'package:road_map_mentor/core/features/starting/presentation/screens/starting_screen.dart';
import 'package:road_map_mentor/core/features/interview/screens/interview_page.dart';
import 'package:road_map_mentor/core/features/interview/screens/field_selection_page.dart';
import 'package:road_map_mentor/core/features/interview/screens/history_screen.dart';
import 'package:road_map_mentor/core/features/interview/screens/score_screen.dart';
import 'package:road_map_mentor/core/features/interview/screens/interview_screen.dart';

abstract class AppRouter {
  static final _roadMapRepos = RoadMapReposImp();

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SpScreen()),
      GoRoute(path: home1, builder: (context, state) => const HomePage1()),
      GoRoute(
        path: startingScreen,
        builder: (context, state) => StartingScreen(),
      ),
      GoRoute(
        path: preferredMessagesScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GetAllPreferredMessagesCubit(),
            ),
            BlocProvider(create: (context) => PreferredMessagesCubit()),
          ],
          child: const PreferredMessagesScreen(),
        ),
      ),
      GoRoute(
        path: chatScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AllMessagesCubit(_roadMapRepos),
            ),
            BlocProvider(create: (context) => PreferredMessagesCubit()),
          ],
          child: const RoadMapChatScreen(),
        ),
      ),
      // Interview Feature Routes
      GoRoute(
        path: interviewPage,
        builder: (context, state) => const InterviewPage(),
      ),
      GoRoute(
        path: fieldSelectionPage,
        builder: (context, state) => const FieldSelectionPage(),
      ),
      GoRoute(
        path: historyScreen,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: scoreScreen,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return ScoreScreen(interviewModel: params['interviewModel']);
        },
      ),
      GoRoute(
        path: interviewScreen,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return InterviewScreen(
            field: params['field'] as String,
            technologies: params['technologies'] as List<String>,
            difficulty: params['difficulty'] as String,
          );
        },
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
  static const String home1 = '/home1'; // Base path

  // Interview Feature Routes
  static const String interviewPage = '/interview';
  static const String fieldSelectionPage = '/interview/field-selection';
  static const String historyScreen = '/interview/history';
  static const String scoreScreen = '/interview/score';
  static const String interviewScreen = '/interview/session';
}
