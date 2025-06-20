import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/cv_analysis/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/cv_analysis/data/repos/analyze_resume_repos_imp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyzeResumeFun {
  void scrollToBottom({required ScrollController scrollController}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> initializePrefs({required BuildContext context}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the existing RoadMapReposImp instance from the cubit
    final reposImpl =
        // ignore: use_build_context_synchronously
        context.read<AnalyzeReumeAllMessagesCubit>().analyzeResumeRepos as AnalyzeResumeReposImp;
    reposImpl.preferences = prefs; // Set the preferences
    await reposImpl.createThread(); // Create thread using the same instance
  }
}
