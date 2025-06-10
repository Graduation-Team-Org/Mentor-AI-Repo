import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_model.dart';

class HistoryService {
  static const String _historyKey = 'interview_history';
  final SharedPreferences _prefs;

  HistoryService(this._prefs);

  // Save a new interview to history
  Future<void> saveInterview(InterviewHistory interview) async {
    List<InterviewHistory> history = await getHistory();
    history.add(interview);

    // Convert to JSON and save
    final List<Map<String, dynamic>> jsonList =
        history.map((interview) => interview.toJson()).toList();
    await _prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  // Get all interview history
  Future<List<InterviewHistory>> getHistory() async {
    final String? historyJson = _prefs.getString(_historyKey);
    if (historyJson == null) return [];

    final List<dynamic> jsonList = jsonDecode(historyJson);
    return jsonList.map((json) => InterviewHistory.fromJson(json)).toList();
  }

  // Get interview history sorted by date (most recent first)
  Future<List<InterviewHistory>> getSortedHistory() async {
    final history = await getHistory();
    history.sort((a, b) => b.date.compareTo(a.date));
    return history;
  }

  // Delete an interview from history
  Future<void> deleteInterview(String id) async {
    List<InterviewHistory> history = await getHistory();
    history.removeWhere((interview) => interview.id == id);

    final List<Map<String, dynamic>> jsonList =
        history.map((interview) => interview.toJson()).toList();
    await _prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  // Clear all history
  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }

  // Get average score for a specific field
  Future<double> getAverageScoreForField(String field) async {
    final history = await getHistory();
    final fieldInterviews = history.where(
      (interview) => interview.field == field,
    );

    if (fieldInterviews.isEmpty) return 0.0;

    final totalScore = fieldInterviews.fold<int>(
      0,
      (sum, interview) => sum + interview.totalScore,
    );

    return totalScore / fieldInterviews.length;
  }

  // Get most common technologies used
  Future<List<String>> getMostCommonTechnologies() async {
    final history = await getHistory();
    final Map<String, int> technologyCount = {};

    for (var interview in history) {
      for (var tech in interview.technologies) {
        technologyCount[tech] = (technologyCount[tech] ?? 0) + 1;
      }
    }

    final sortedTechnologies =
        technologyCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTechnologies.map((e) => e.key).toList();
  }
}
