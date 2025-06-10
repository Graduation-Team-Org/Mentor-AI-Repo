import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDB {
  final String _emptyThreadsKey = 'empty_threads';
  final  SharedPreferences prefs;

  SharedPreferencesDB({required this.prefs});

  Future<void> saveEmptyThread(String threadId) async {
    List<String> emptyThreads = prefs.getStringList(_emptyThreadsKey) ?? [];
    if (!emptyThreads.contains(threadId)) {
      emptyThreads.add(threadId);
      await prefs.setStringList(_emptyThreadsKey, emptyThreads);
      print("Saved empty thread: $threadId");
    }
  }

  Future<String?> getEmptyThread() async {
    List<String> emptyThreads = prefs.getStringList(_emptyThreadsKey) ?? [];
    if (emptyThreads.isNotEmpty) {
      return emptyThreads[0];
    }
    return null;
  }

  Future<void> removeEmptyThread(String threadId) async {
    List<String> emptyThreads = prefs.getStringList(_emptyThreadsKey) ?? [];
    emptyThreads.remove(threadId);
    await prefs.setStringList(_emptyThreadsKey, emptyThreads);
    print("Removed used thread: $threadId");
  }
}
