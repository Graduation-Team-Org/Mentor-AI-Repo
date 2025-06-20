import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:road_map_mentor/core/features/cv_analysis/services/analyze_resume_chat_session.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class AnalyzeResumeHistoryListView extends StatefulWidget {
  const AnalyzeResumeHistoryListView({super.key});

  @override
  State<AnalyzeResumeHistoryListView> createState() => _AnalyzeResumeHistoryListViewState();
}

class _AnalyzeResumeHistoryListViewState extends State<AnalyzeResumeHistoryListView> {
  List<Map<String, dynamic>> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await AnalyzeResumeChatSessionService.getAllChatSessions();
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_sessions.isEmpty) {
      return Center(
        child: Text(
          'No chat history yet',
          style: body.copyWith(color: AppColors.white.withOpacity(0.7)),
        ),
      );
    }

    return ListView.builder(
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        final createdAt = DateTime.parse(session['createdAt']);
        final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(createdAt);

        return ListTile(
          title: Text(
            session['sessionTitle'],
            style: body.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          subtitle: Text(
            formattedDate,
            style: TextStyle(color: AppColors.white.withOpacity(0.6)),
          ),
          onTap: () {
            context.go(
              AppRouter.chatSessions,
              extra: {'sessionId': session['sessionId']},
            );
          },
        );
      },
    );
  }
}
