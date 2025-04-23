import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class ChatWithDocPage extends StatefulWidget {
  const ChatWithDocPage({super.key});

  @override
  State<ChatWithDocPage> createState() => _ChatWithDocPageState();
}

class _ChatWithDocPageState extends State<ChatWithDocPage> {
  bool _isUploading = false;
  List<Map<String, dynamic>> _files = [];

  void _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      for (var file in result.files) {
        setState(() {
          _files.add({
            'name': file.name,
            'path': file.path,
            'progress': 0.0,
            'isUploading': true,
            'isCompleted': false,
            'uploadFailed': false,
          });
        });
        _simulateFileUpload(file.name);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No files selected')),
      );
    }
  }

  void _simulateFileUpload(String fileName) async {
    await Future.delayed(const Duration(seconds: 1));
    for (var i = 1; i <= 80; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        var index = _files.indexWhere((file) => file['name'] == fileName);
        if (index != -1) {
          _files[index]['progress'] = i / 100.0;
        }
      });
    }


    if (fileName.contains('Sample')) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        var index = _files.indexWhere((file) => file['name'] == fileName);
        if (index != -1) {
          _files[index]['isUploading'] = false;
          _files[index]['uploadFailed'] = true;
        }
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      var index = _files.indexWhere((file) => file['name'] == fileName);
      if (index != -1) {
        _files[index]['isUploading'] = false;
        _files[index]['isCompleted'] = true;
      }
    });


    if (_files.where((file) => !file['uploadFailed']).every((file) => file['isCompleted'])) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) => const ProcessingScreen()),
      // );
    }
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110A2B),
      body: Stack(
        children: [
          Positioned(
            top: 300,
            left: 60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF352250),
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -70,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF9860E4),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 200,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF9860E4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF40174C)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/home2.png"),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DottedBorder(
                  color: Colors.white,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  child: GestureDetector(
                    onTap: _selectFiles,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _files.isEmpty
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_copy, color: Colors.white70, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Click to upload one or more documents\nto process and start chatting with it',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Color(0xFF9860E4), size: 40),
                            SizedBox(height: 10),
                            Text(
                              '${_files.length} file selected',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: _files.length,
                  separatorBuilder: (context, index) => const Divider(color: Color(0xFF3F1E74)),
                  itemBuilder: (context, index) {
                    final file = _files[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white24, width: 2),
                      ),
                      color: Color.fromRGBO(255, 255, 255, 0.01),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        height: 90,
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file, color: Colors.white, size: 30),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    file['name'],
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 15),
                                  if (file['isUploading'])
                                    LinearProgressIndicator(
                                      value: file['progress'],
                                      backgroundColor: Colors.white70,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9860E4)),
                                    ),
                                  if (file['uploadFailed'])
                                    const Text(
                                      'Upload failed, please try again',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (file['isUploading'])
                              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F1E74)))),
                            if (!file['isUploading'] && !file['uploadFailed'])
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () => _removeFile(index),
                              ),
                            if (file['uploadFailed'])
                              IconButton(
                                icon: const Icon(Icons.refresh, color: Color(0xFF3F1E74)),
                                onPressed: () {
                                  setState(() {
                                    file['isUploading'] = true;
                                    file['uploadFailed'] = false;
                                    file['progress'] = 0.0;
                                  });
                                  _simulateFileUpload(file['name']);
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_files.where((file) => file['isCompleted']).isNotEmpty)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProcessingScreen()),
                        );
                      },
                      backgroundColor:const Color(0xFF9860E4),
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
                      shape: StadiumBorder(),
                    ),
                  ),
                ),
            ],
          ),
        ],

      ),
    );
  }
}


class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChatWithDocumentScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110A2B),
      body: Stack(
        children: [
          Positioned(
            top: 300,
            left: 60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF352250),
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -70,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF9860E4),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 200,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF9860E4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF40174C)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/home2.png"),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  color: Color(0xFF9860E4),
                  strokeWidth: 4,
                ),
                SizedBox(height: 20),
                Text(
                  'Documents processing...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ChatWithDocumentScreen extends StatefulWidget {
  @override
  _ChatWithDocumentScreenState createState() => _ChatWithDocumentScreenState();
}



class _ChatWithDocumentScreenState extends State<ChatWithDocumentScreen>
    with TickerProviderStateMixin {
  String _userName = 'User';
  bool _hasStarted = false;
  late Animation<Offset> _animation;
  late AnimationController _controller;

  bool _isSidebarOpen = false;
  List<String> _chatHistory = [];
  List<Map<String, String>> messages = [];

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _searchController = TextEditingController();


  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('user_name');
    setState(() {
      if (userName != null && userName.isNotEmpty) {
        _userName = userName;
      }
    });
  }

  List<String> _filteredChatHistory = [];


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    _loadUserName();

    _showHistoryAndInitializeFilter();
  }

  Future<void> _showHistoryAndInitializeFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatHistory = prefs.getStringList('chat_history') ?? [];
    setState(() {
      _chatHistory = chatHistory;
      _filteredChatHistory = _chatHistory;
    });
  }

  void _filterChatHistory(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _filteredChatHistory = _chatHistory
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _filteredChatHistory = _chatHistory;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatHistory = prefs.getStringList('chat_history') ?? [];
    setState(() {
      _chatHistory = chatHistory;
    });
  }

  void _loadConversation(String conversationName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedMessages = prefs.getString(conversationName);

    if (encodedMessages != null) {
      List<dynamic> decodedMessages = jsonDecode(encodedMessages);
      setState(() {
        messages = decodedMessages
            .map((msg) => Map<String, String>.from(msg))
            .toList();
      });
    }
  }

  void _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages = jsonEncode(messages);
    prefs.setString('chat_history', encodedMessages);
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _startNewChat() {
    setState(() {
      String conversationName = "chat ${DateTime.now().millisecondsSinceEpoch}";
      _saveConversation(conversationName);
      messages.clear();
      _isSidebarOpen = false;
    });
  }

  void _saveConversation(String conversationName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages = jsonEncode(messages);
    prefs.setString(conversationName, encodedMessages);


    List<String> chatHistory = prefs.getStringList('chat_history') ?? [];
    chatHistory.add(conversationName);
    prefs.setStringList('chat_history', chatHistory);
  }



  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        messages.add({
          'from': 'User',
          'text': message,
        });
        _hasStarted = true;
      });
      _saveMessages();
      _controllerText.clear();
    }
  }


  void _shareChat() {
    final text = messages.map((e) => "${e['from']}: ${e['text']}").join("\n\n");
    Share.share(text);
    setState(() => _isSidebarOpen = false);
  }



  Widget _buildMessage(String from, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: from == 'User' ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (from != 'User')
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage('assets/images/home2.png'),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: from == 'User' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  from,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purpleAccent.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (from == 'User')
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF110A2B),
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 300,
                  left: 60,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF352250),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -30,
                  right: -70,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF9860E4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 200,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF9860E4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  right: 50,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF40174C),
                      ),
                    ),
                  ),
                ),
                // محتوى الصفحة
                Column(
                  children: [
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            'Chat with document',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_calendar_rounded, color: Colors.white),
                                onPressed: _startNewChat,
                              ),
                              IconButton(
                                icon: Icon(Icons.view_sidebar_outlined, color: Colors.white),
                                onPressed: _toggleSidebar,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_hasStarted,
                      child: Expanded(
                        child: SlideTransition(
                          position: _animation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/images/home2.png'),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Hello, I ’m Serena 👋",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Let's chat with your documents!",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessage(
                            messages[index]['from'] ?? 'Unknown',
                            messages[index]['text'] ?? '',
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controllerText,
                              decoration: InputDecoration(
                                hintText: "Ask what's on your mind...",
                                hintStyle: const TextStyle(color: Colors.white30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: const Color(0xFF605B6C)),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          FloatingActionButton(
                            backgroundColor: Color(0xFF9860E4),
                            shape: CircleBorder(),
                            child: Transform.rotate(
                              angle: -50 * 3.14159 / 180,
                              child: const Icon(Icons.send, color: Colors.white),
                            ),
                            onPressed: () {
                              _sendMessage(_controllerText.text);
                            },
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isSidebarOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSidebarOpen = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          if (_isSidebarOpen)
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 250,
                color: Color(0xFF110A2B),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/home2.png'),
                                ),
                                SizedBox(width: 10),
                                Text("Serena", style: TextStyle(color: Colors.white, fontSize: 18)),
                              ],
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.search, color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              onChanged: _filterChatHistory,
                            ),
                            SizedBox(height: 20),
                            ListTile(
                              leading: Icon(Icons.share, color: Colors.white),
                              title: Text("Share Chat", style: TextStyle(color: Colors.white)),
                              onTap: _shareChat,
                            ),
                            ListTile(
                              leading: Icon(Icons.chat, color: Colors.white),
                              title: Text("New Chat", style: TextStyle(color: Colors.white)),
                              onTap: _startNewChat,
                            ),
                            ListTile(
                              leading: Icon(Icons.history, color: Colors.white),
                              title: Text("History", style: TextStyle(color: Colors.white)),
                              onTap: _showHistory,
                            ),
                            ListTile(
                              leading: Icon(Icons.favorite, color: Colors.white),
                              title: Text("Preferred message", style: TextStyle(color: Colors.white)),
                              onTap: () {},
                            ),
                            SizedBox(height: 20),
                            Text('History:', style: TextStyle(color: Colors.white70)),
                            ..._filteredChatHistory.map((history) {
                              return ListTile(
                                title: Text(history, style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  _loadConversation(history);
                                  setState(() {
                                    _isSidebarOpen = false;
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage("assets/images/user.png"),
                          ),
                          SizedBox(width: 10),
                          Text('User', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}











