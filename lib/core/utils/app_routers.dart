import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/screens/chat_message_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppRouter {
  static final _roadMapRepos = RoadMapReposImp();  // Single instance

  // GoRouter configuration
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => AllMessagesCubit(_roadMapRepos),
          child: ChatScreen(),
        ),
      ),
    ],
  );

}
