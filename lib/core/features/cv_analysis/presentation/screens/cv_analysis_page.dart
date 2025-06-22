import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';
import 'package:road_map_mentor/core/utils/app_routers.dart';

class CvAnalysisPage extends StatefulWidget {
  const CvAnalysisPage({super.key});

  @override
  State<CvAnalysisPage> createState() => _CvAnalysisPageState();
}

class _CvAnalysisPageState extends State<CvAnalysisPage> {
  String? _fileName;
  bool isProcessing = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _startProcessing() async {
    setState(() {
      isProcessing = true;
    });

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      isProcessing = false;
    });
    context.go(AppRouter.analyzeResumeScreen, extra: {
      'fileName': _fileName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
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
                  color: Color(0xFF40174C),
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
                onPressed: () => context.go('/home'),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/home3.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DottedBorder(
                  color: Colors.white,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(15),
                  child: GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _fileName == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icon_upload.svg',
                                    width: 40,
                                    height: 40,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Upload your CV here to process\nand analyze it",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              )
                            : Text(
                                _fileName!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: _fileName != null
                    ? () {
                        _startProcessing();
                      }
                    : _pickFile,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF9860E4),
                  child: isProcessing
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : Icon(
                          _fileName != null
                              ? Icons.arrow_forward
                              : Icons.upload,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   String _userName = 'User';
//   bool _hasStarted = false;
//   late Animation<Offset> _animation;
//   late AnimationController _controller;

//   bool _isSidebarOpen = false;
//   List<String> _chatHistory = [];
//   List<Map<String, String>> messages = [];

//   TextEditingController _controllerText = TextEditingController();
//   TextEditingController _searchController = TextEditingController();

//   Future<void> _loadUserName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userName = prefs.getString('user_name');
//     setState(() {
//       if (userName != null && userName.isNotEmpty) {
//         _userName = userName;
//       }
//     });
//   }

//   List<String> _filteredChatHistory = [];

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _controller.forward();
//     _loadUserName();

//     _showHistoryAndInitializeFilter();
//   }

//   Future<void> _showHistoryAndInitializeFilter() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> chatHistory = prefs.getStringList('chat_history') ?? [];
//     setState(() {
//       _chatHistory = chatHistory;
//       _filteredChatHistory = _chatHistory;
//     });
//   }

//   void _filterChatHistory(String query) {
//     setState(() {
//       if (query.isNotEmpty) {
//         _filteredChatHistory = _chatHistory
//             .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       } else {
//         _filteredChatHistory = _chatHistory;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _showHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> chatHistory = prefs.getStringList('chat_history') ?? [];
//     setState(() {
//       _chatHistory = chatHistory;
//     });
//   }

//   void _loadConversation(String conversationName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? encodedMessages = prefs.getString(conversationName);

//     if (encodedMessages != null) {
//       List<dynamic> decodedMessages = jsonDecode(encodedMessages);
//       setState(() {
//         messages = decodedMessages
//             .map((msg) => Map<String, String>.from(msg))
//             .toList();
//       });
//     }
//   }

//   void _saveMessages() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String encodedMessages = jsonEncode(messages);
//     prefs.setString('chat_history', encodedMessages);
//   }

//   void _toggleSidebar() {
//     setState(() {
//       _isSidebarOpen = !_isSidebarOpen;
//     });
//   }

//   void _startNewChat() {
//     setState(() {
//       String conversationName =
//           "محادثة ${DateTime.now().millisecondsSinceEpoch}";
//       _saveConversation(conversationName);
//       messages.clear();
//       _isSidebarOpen = false;
//     });
//   }

//   void _saveConversation(String conversationName) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String encodedMessages = jsonEncode(messages);
//     prefs.setString(conversationName, encodedMessages);

//     List<String> chatHistory = prefs.getStringList('chat_history') ?? [];
//     chatHistory.add(conversationName);
//     prefs.setStringList('chat_history', chatHistory);
//   }

//   void _sendMessage(String message) {
//     if (message.isNotEmpty) {
//       setState(() {
//         messages.add({
//           'from': 'User',
//           'text': message,
//         });
//         _hasStarted = true;
//       });
//       _saveMessages();
//       _controllerText.clear();
//     }
//   }

//   void _shareChat() {
//     final text = messages.map((e) => "${e['from']}: ${e['text']}").join("\n\n");
//     Share.share(text);
//     setState(() => _isSidebarOpen = false);
//   }

//   Widget _buildMessage(String from, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//       child: Row(
//         mainAxisAlignment:
//             from == 'User' ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (from != 'User')
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.transparent,
//                 child: ClipOval(
//                   child: Image.asset(
//                     "assets/images/home3.png",
//                     width: 60,
//                     height: 60,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: from == 'User'
//                   ? CrossAxisAlignment.end
//                   : CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   from,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.purpleAccent.withOpacity(0.8),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Container(
//                   padding: const EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                     color: Colors.purpleAccent.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(15),
//                     border:
//                         Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
//                   ),
//                   child: Text(
//                     text,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (from == 'User')
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.transparent,
//                 child: ClipOval(
//                   child: Image.asset(
//                     "assets/images/user.png",
//                     width: 60,
//                     height: 60,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF110A2B),
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 300,
//                   left: 60,
//                   child: ImageFiltered(
//                     imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                     child: Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFF352250),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: -30,
//                   right: -70,
//                   child: ImageFiltered(
//                     imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
//                     child: Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFF9860E4),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 100,
//                   left: 200,
//                   child: ImageFiltered(
//                     imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFF9860E4),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 50,
//                   right: 50,
//                   child: ImageFiltered(
//                     imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                     child: Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFF40174C),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     SizedBox(height: 30),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: 16, right: 16, bottom: 16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.arrow_back, color: Colors.white),
//                             onPressed: () => context.go('/home'),
//                           ),
//                           Text(
//                             'CV Analysis',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               IconButton(
//                                 icon: SvgPicture.asset(
//                                   'assets/images/Pen_New_Square_cv.svg',
//                                   width: 24,
//                                   height: 24,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: _startNewChat,
//                               ),
//                               IconButton(
//                                 icon: SvgPicture.asset(
//                                   'assets/images/Sidebar_Minimalistic.svg',
//                                   width: 24,
//                                   height: 24,
//                                   color: Colors.white,
//                                 ),
//                                 onPressed: _toggleSidebar,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Visibility(
//                       visible: !_hasStarted,
//                       child: Expanded(
//                         child: SlideTransition(
//                           position: _animation,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: Colors.transparent,
//                                 child: ClipOval(
//                                   child: Image.asset(
//                                     "assets/images/home3.png",
//                                     width: 60,
//                                     height: 60,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 "Hello, I ’m Marcus 👋",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 "Let’s explore your CV's full potential!",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: messages.length,
//                         itemBuilder: (context, index) {
//                           return _buildMessage(
//                             messages[index]['from'] ?? 'Unknown',
//                             messages[index]['text'] ?? '',
//                           );
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _controllerText,
//                               decoration: InputDecoration(
//                                 hintText: "Ask what's on your mind...",
//                                 hintStyle:
//                                     const TextStyle(color: Colors.white30),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                   borderSide: BorderSide(
//                                       color: const Color(0xFF605B6C)),
//                                 ),
//                               ),
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           FloatingActionButton(
//                             backgroundColor: Color(0xFF9860E4),
//                             shape: CircleBorder(),
//                             child: SvgPicture.asset(
//                               'assets/images/lucid_send.svg',
//                               width: 24,
//                               height: 24,
//                               color: Colors.white,
//                             ),
//                             onPressed: () {
//                               _sendMessage(_controllerText.text);
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (_isSidebarOpen)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _isSidebarOpen = false;
//                 });
//               },
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ),
//           if (_isSidebarOpen)
//             AnimatedPositioned(
//               duration: Duration(milliseconds: 300),
//               left: 0,
//               top: 0,
//               bottom: 0,
//               child: Container(
//                 width: 250,
//                 color: Color(0xFF110A2B),
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 CircleAvatar(
//                                   backgroundImage:
//                                       AssetImage('assets/images/home3.png'),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text("Marcus",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 18)),
//                               ],
//                             ),
//                             SizedBox(height: 20),
//                             TextField(
//                               controller: _searchController,
//                               decoration: InputDecoration(
//                                 hintText: "Search",
//                                 hintStyle: TextStyle(color: Colors.white70),
//                                 suffixIcon: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 12),
//                                   child: SvgPicture.asset(
//                                     'assets/images/fi_search.svg',
//                                     width: 20,
//                                     height: 20,
//                                     color: Colors.white70,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white10,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                               style: TextStyle(color: Colors.white),
//                               onChanged: _filterChatHistory,
//                             ),
//                             SizedBox(height: 20),
//                             ListTile(
//                               leading: SvgPicture.asset(
//                                 'assets/images/fi_share-2.svg',
//                                 width: 24,
//                                 height: 24,
//                                 color: Colors.white,
//                               ),
//                               title: Text(
//                                 "Share Chat",
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               onTap: _shareChat,
//                             ),
//                             ListTile(
//                               leading: SvgPicture.asset(
//                                 'assets/images/Pen_New_Square_cv.svg',
//                                 width: 24,
//                                 height: 24,
//                                 color: Colors.white,
//                               ),
//                               title: Text("New Chat",
//                                   style: TextStyle(color: Colors.white)),
//                               onTap: _startNewChat,
//                             ),
//                             ListTile(
//                               leading: SvgPicture.asset(
//                                 'assets/images/Document_Text.svg',
//                                 width: 24,
//                                 height: 24,
//                                 color: Colors.white,
//                               ),
//                               title: Text("History",
//                                   style: TextStyle(color: Colors.white)),
//                               onTap: _showHistory,
//                             ),
//                             ListTile(
//                               leading: SvgPicture.asset(
//                                 'assets/images/Heart_Angle.svg',
//                                 width: 24,
//                                 height: 24,
//                                 color: Colors.white,
//                               ),
//                               title: Text("Preferred message",
//                                   style: TextStyle(color: Colors.white)),
//                               onTap: () {},
//                             ),
//                             SizedBox(height: 20),
//                             Text('History:',
//                                 style: TextStyle(color: Colors.white70)),
//                             ..._filteredChatHistory.map((history) {
//                               return ListTile(
//                                 title: Text(history,
//                                     style: TextStyle(color: Colors.white)),
//                                 onTap: () {
//                                   _loadConversation(history);
//                                   setState(() {
//                                     _isSidebarOpen = false;
//                                   });
//                                 },
//                               );
//                             }).toList(),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Colors.transparent,
//                             child: ClipOval(
//                               child: Image.asset(
//                                 "assets/images/user.png",
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Text('User', style: TextStyle(color: Colors.white70)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
