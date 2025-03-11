import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/saved_all_messages_cubit/saved_all_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/chat_message_screen.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/saved_all_messages_screen.dart';

abstract class AppRouter {
  static final _roadMapRepos = RoadMapReposImp();

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => AllMessagesCubit(_roadMapRepos),
          child: const ChatScreen(),
        ),
      ),
      GoRoute(
        path: '$savedAllMessagesScreen/:title',  // Update path pattern
        builder: (context, state) => BlocProvider(
          create: (context) => SavedAllMessagesCubit(_roadMapRepos),
          child: SavedAllMessagesScreen(
            title: state.pathParameters['title']!,
          ),
        ),
      ),
    ],
  );
  static const String savedAllMessagesScreen = '/saved';  // Base path
}