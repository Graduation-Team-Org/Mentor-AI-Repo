import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../services/chat_sharing_service.dart';
import '../utils/chat_utils.dart';
import '../models/chat_message.dart';
import '../widgets/chat/message_bubble.dart';
import 'package:go_router/go_router.dart';

class ChatWithDocPage extends StatefulWidget {
  const ChatWithDocPage({super.key});

  @override
  State<ChatWithDocPage> createState() => _ChatWithDocPageState();
}

class _ChatWithDocPageState extends State<ChatWithDocPage> {
  List<Map<String, dynamic>> _files = [];
  bool _isDragging = false;

  // Original message handling variables and methods
  List<Map<String, dynamic>> messages = [];
  bool _hasStarted = false;
  bool _isSidebarOpen = false;
  bool _isSendingMessage = false;
  TextEditingController _controllerText = TextEditingController();
  List<String> _chatHistory = []; // Placeholder for chat history

  void _refreshChatHistoryList() {
    // Placeholder implementation
    print('Refreshing chat history list');
  }

  void _saveCurrentConversation(String name) {
    // Placeholder implementation
    print('Saving current conversation: $name');
  }

  void _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      for (var file in result.files) {
        if (file.path != null) {
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
          _uploadFile(file.path!, file.name);
        }
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No files selected')));
    }
  }

  void _uploadFile(String filePath, String fileName) async {
    int fileIndex = _files.indexWhere((file) => file['name'] == fileName);
    if (fileIndex == -1) return;

    setState(() {
      _files[fileIndex]['isUploading'] = true;
      _files[fileIndex]['uploadFailed'] = false;
      _files[fileIndex]['progress'] = 0.0;
    });

    try {
      // Show a snackbar to indicate upload start
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Uploading $fileName...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      for (var i = 1; i <= 80; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        setState(() {
          _files[fileIndex]['progress'] = i / 100.0;
        });
      }

      await ApiService.uploadPdf(filePath);

      if (!mounted) return;
      setState(() {
        _files[fileIndex]['isUploading'] = false;
        _files[fileIndex]['isCompleted'] = true;
        _files[fileIndex]['progress'] = 1.0;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('$fileName uploaded successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error uploading $fileName: $e');
      if (!mounted) return;
      setState(() {
        _files[fileIndex]['isUploading'] = false;
        _files[fileIndex]['uploadFailed'] = true;
        _files[fileIndex]['progress'] = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Failed to upload $fileName: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _uploadFile(filePath, fileName),
          ),
        ),
      );
    }
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  Future<void> _showFilePreview(String filePath, String fileName) async {
    final file = File(filePath);
    final size = await file.length();
    final sizeInMB = size / (1024 * 1024);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFF110A2B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/File_Text.svg',
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Size: ${sizeInMB.toStringAsFixed(2)} MB',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDragEnter(dynamic event) {
    setState(() {
      _isDragging = true;
    });
  }

  void _handleDragLeave(dynamic event) {
    setState(() {
      _isDragging = false;
    });
  }

  void _handleDragOver(dynamic event) {
    event.preventDefault();
  }

  void _handleDrop(dynamic event) async {
    event.preventDefault();
    setState(() {
      _isDragging = false;
    });

    // Handle dropped files
    if (event.dataTransfer.files != null) {
      for (var file in event.dataTransfer.files) {
        if (file.path != null) {
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
          _uploadFile(file.path!, file.name);
        }
      }
    }
  }

  void _startNewChat() async {
    // Don't clear the entire history, just start a new chat
    setState(() {
      messages.clear();
      _hasStarted = false;
      _isSidebarOpen = false;
      _controllerText.clear();
    });
  }

  void _sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'from': 'User', 'text': userMessage});
      _hasStarted = true;
      _isSendingMessage = true;
    });
    _controllerText.clear();

    // If this is the first message, use it to name the conversation
    if (messages.length == 1) {
      // Changed from _chatHistory.isEmpty to messages.length == 1
      String conversationName = ChatUtils.generateConversationName(userMessage);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> chatMetadata = prefs.getStringList('chat_metadata') ?? [];
      chatMetadata.add(conversationName);
      await prefs.setStringList('chat_metadata', chatMetadata);
      _refreshChatHistoryList();

      // Save the initial message
      _saveCurrentConversation(conversationName);
    }

    try {
      final response = await ApiService.askQuestion(userMessage);

      if (mounted && response != null && response['answer'] != null) {
        setState(() {
          messages.add({'from': 'Serena', 'text': response['answer']});
        });

        // Save the conversation after each message
        if (_chatHistory.isNotEmpty) {
          _saveCurrentConversation(_chatHistory.last);
        }
      } else if (mounted) {
        setState(() {
          messages.add({
            'from': 'Serena',
            'text': 'Sorry, I could not get a response. Please try again.',
          });
        });
      }
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        setState(() {
          messages.add({
            'from': 'Serena',
            'text': 'An error occurred: ${e.toString()}',
          });
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingMessage = false;
        });
      }
    }
  }

  void _shareChat() async {
    if (messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No messages to share')),
      );
      return;
    }

    try {
      setState(() => _isSendingMessage = true);

      // Convert messages to ChatMessage objects
      final chatMessages = messages
          .map((msg) => ChatMessage(from: msg['from']!, text: msg['text']!))
          .toList();

      final shareUrl = await ChatSharingService.shareChat(chatMessages);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Share Chat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Share this link with others:'),
              SizedBox(height: 8),
              SelectableText(
                shareUrl,
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: shareUrl));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Link copied to clipboard')),
                );
                Navigator.pop(context);
              },
              child: Text('Copy Link'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing chat: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingMessage = false);
      }
    }
  }

  Widget _buildMessage(String from, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            from == 'User' ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (from != 'User')
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/home2.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: from == 'User'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
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
                    border: Border.all(
                      color: Colors.purpleAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/user.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
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
                    SizedBox(height: 40),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/home2.png",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DottedBorder(
                        color: _isDragging ? Color(0xFF9860E4) : Colors.white,
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
                              color: _isDragging
                                  ? Color(0xFF9860E4).withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: _files.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Folders.svg',
                                          width: 40,
                                          height: 40,
                                          color: _isDragging
                                              ? Color(0xFF9860E4)
                                              : Colors.white70,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          _isDragging
                                              ? 'Drop your PDF files here'
                                              : 'Click or drag PDF files here\nto process and start chatting',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isDragging
                                                ? Color(0xFF9860E4)
                                                : Colors.white70,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF9860E4),
                                          size: 40,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '${_files.length} file${_files.length > 1 ? 's' : ''} selected',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
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
                        separatorBuilder: (context, index) =>
                            const Divider(color: Color(0xFF3F1E74)),
                        itemBuilder: (context, index) {
                          final file = _files[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.white24, width: 2),
                            ),
                            color: Color.fromRGBO(255, 255, 255, 0.01),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              height: 90,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/File_Text.svg',
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _showFilePreview(
                                            file['path']!,
                                            file['name'],
                                          ),
                                          child: Text(
                                            file['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        if (file['isUploading'])
                                          LinearProgressIndicator(
                                            value: file['progress'],
                                            backgroundColor: Colors.white70,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              Color(0xFF9860E4),
                                            ),
                                          ),
                                        if (file['uploadFailed'])
                                          const Text(
                                            'Upload failed, please try again',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (file['isUploading'])
                                    const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color(0xFF3F1E74),
                                        ),
                                      ),
                                    ),
                                  if (!file['isUploading'] &&
                                      !file['uploadFailed'])
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/images/Trash_Bin_Minimalistic.svg',
                                        width: 24,
                                        height: 24,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => _removeFile(index),
                                    ),
                                  if (file['uploadFailed'])
                                    IconButton(
                                      icon: const Icon(
                                        Icons.refresh,
                                        color: Color(0xFF3F1E74),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          file['isUploading'] = true;
                                          file['uploadFailed'] = false;
                                          file['progress'] = 0.0;
                                        });
                                        _uploadFile(
                                            file['path']!, file['name']);
                                      },
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_files
                            .where((file) => file['isCompleted'])
                            .isNotEmpty &&
                        _files.every(
                          (file) => file['isCompleted'] || file['uploadFailed'],
                        ))
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 40.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Files uploaded successfully!',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              FloatingActionButton.extended(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProcessingScreen(
                                          file: File(_files.first['path']!)),
                                    ),
                                  );
                                },
                                label: const Text('Next'),
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                              SizedBox(
                                height: _files.length > 1 ? 10 : 0,
                              ), // Spacing only if more than one file
                              FloatingActionButton.extended(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatWithDocumentScreen(
                                              chatHistory: []),
                                    ),
                                  );
                                },
                                label: const Text('Skip'),
                                icon: const Icon(Icons.skip_next),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_files.isEmpty)
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 40.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Or continue without uploading',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              FloatingActionButton.extended(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatWithDocumentScreen(
                                              chatHistory: []),
                                    ),
                                  );
                                },
                                label: const Text('Skip'),
                                icon: const Icon(Icons.skip_next),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Message Input and Chat Display (Original structure)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Visibility(
              visible: _hasStarted, // Only visible when chat has started
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.go('/home'),
                    ),
                    title: Text('Chat with Document',
                        style: TextStyle(color: Colors.white)),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.white),
                        onPressed: _shareChat, // Original _shareChat
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white),
                        onPressed: _startNewChat, // Original _startNewChat
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length + (_isSendingMessage ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return _buildMessage('Serena',
                              '...'); // Original placeholder for sending
                        }
                        return _buildMessage(
                          messages[index]['from'] ?? 'Unknown',
                          messages[index]['text'] ?? '',
                        ); // Original message display
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controllerText,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onSubmitted: _sendMessage,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _sendMessage(_controllerText.text),
                        ),
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

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key, required this.file});
  final File file;

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
        MaterialPageRoute(
            builder: (_) => ChatWithDocumentScreen(
                  chatHistory: [],
                )),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/home2.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
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
                  style: TextStyle(color: Colors.white70, fontSize: 16),
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
  const ChatWithDocumentScreen({super.key, required this.chatHistory});
  final List<String> chatHistory;

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
  List<ChatMessage> messages = [];

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  bool _isSendingMessage = false;

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
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    _loadUserName();

    _showHistoryAndInitializeFilter();
  }

  Future<void> _showHistoryAndInitializeFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatHistory = prefs.getStringList('chat_metadata') ?? [];
    setState(() {
      _chatHistory = chatHistory;
      _filteredChatHistory = chatHistory;
    });
  }

  void _filterChatHistory(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _filteredChatHistory = _chatHistory
            .where(
              (item) => item.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      } else {
        _filteredChatHistory = _chatHistory;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerText.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _refreshChatHistoryList() async {
    await _showHistoryAndInitializeFilter();
  }

  void _loadConversation(String conversationName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedMessages = prefs.getString(conversationName);

    if (encodedMessages != null) {
      List<dynamic> decodedMessages = jsonDecode(encodedMessages);
      setState(() {
        messages = decodedMessages
            .map((msg) => ChatMessage.fromMap(Map<String, dynamic>.from(msg)))
            .toList();
        _hasStarted = messages.isNotEmpty;
      });
    } else {
      setState(() {
        messages.clear();
        _hasStarted = false;
      });
    }
  }

  void _saveCurrentConversation(String conversationName) async {
    if (messages.isEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages =
        jsonEncode(messages.map((msg) => msg.toMap()).toList());
    await prefs.setString(conversationName, encodedMessages);

    // Update chat history if needed
    List<String> chatMetadata = prefs.getStringList('chat_metadata') ?? [];
    if (!chatMetadata.contains(conversationName)) {
      chatMetadata.add(conversationName);
      await prefs.setStringList('chat_metadata', chatMetadata);
      _refreshChatHistoryList();
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _startNewChat() async {
    setState(() {
      messages.clear();
      _hasStarted = false;
      _isSidebarOpen = false;
      _controllerText.clear();
    });
  }

  void _sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(
          from: 'User',
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now()));
      _hasStarted = true;
      _isSendingMessage = true;
    });
    _controllerText.clear();

    if (messages.length == 1) {
      String conversationName = ChatUtils.generateConversationName(userMessage);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> chatMetadata = prefs.getStringList('chat_metadata') ?? [];
      chatMetadata.add(conversationName);
      await prefs.setStringList('chat_metadata', chatMetadata);
      _refreshChatHistoryList();
      _saveCurrentConversation(conversationName);
    }

    try {
      final response = await ApiService.askQuestion(userMessage);

      if (mounted && response != null && response['answer'] != null) {
        setState(() {
          messages.add(ChatMessage(
              from: 'Serena',
              text: response['answer'],
              isUser: false,
              timestamp: DateTime.now()));
        });
        if (_chatHistory.isNotEmpty) {
          _saveCurrentConversation(_chatHistory.last);
        }
      } else if (mounted) {
        setState(() {
          messages.add(ChatMessage(
              from: 'Serena',
              text: 'Sorry, I could not get a response. Please try again.',
              isUser: false,
              timestamp: DateTime.now()));
        });
      }
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        setState(() {
          messages.add(ChatMessage(
              from: 'Serena',
              text: 'An error occurred: ${e.toString()}',
              isUser: false,
              timestamp: DateTime.now()));
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingMessage = false;
        });
      }
    }
  }

  void _shareChat() async {
    if (messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No messages to share')),
      );
      return;
    }

    try {
      setState(() => _isSendingMessage = true);

      final shareUrl = await ChatSharingService.shareChat(messages);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Share Chat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Share this link with others:'),
              SizedBox(height: 8),
              SelectableText(
                shareUrl,
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: shareUrl));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Link copied to clipboard')),
                );
                Navigator.pop(context);
              },
              child: Text('Copy Link'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing chat: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingMessage = false);
      }
    }
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
                Column(
                  children: [
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => context.go('/home'),
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
                                icon: SvgPicture.asset(
                                  'assets/images/Pen_New_Square_cv.svg',
                                  width: 24,
                                  height: 24,
                                  color: Colors.white,
                                ),
                                onPressed: _startNewChat,
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/images/Sidebar_Minimalistic.svg',
                                  width: 24,
                                  height: 24,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleSidebar,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_hasStarted && !_isSendingMessage,
                      child: Expanded(
                        child: SlideTransition(
                          position: _animation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/home2.png',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                        padding: EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(message: messages[index]);
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
                                hintStyle: const TextStyle(
                                  color: Colors.white30,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF605B6C),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF605B6C),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Color(0xFF9860E4),
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              onSubmitted: _sendMessage,
                              enabled: !_isSendingMessage,
                            ),
                          ),
                          const SizedBox(width: 10),
                          FloatingActionButton(
                            backgroundColor: Color(0xFF9860E4),
                            shape: CircleBorder(),
                            child: _isSendingMessage
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  )
                                : SvgPicture.asset(
                                    'assets/images/lucid_send.svg',
                                    width: 24,
                                    height: 24,
                                    color: Colors.white,
                                  ),
                            onPressed: _isSendingMessage
                                ? null
                                : () {
                                    _sendMessage(_controllerText.text);
                                  },
                          ),
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
              child: Container(color: Colors.black.withOpacity(0.5)),
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
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/home2.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Serena",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(color: Colors.white70),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/fi_search.svg',
                                    width: 20,
                                    height: 20,
                                    color: Colors.white70,
                                  ),
                                ),
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
                              leading: SvgPicture.asset(
                                'assets/images/fi_share-2.svg',
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Share Chat",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: _shareChat,
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                'assets/images/Pen_New_Square_cv.svg',
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                              title: Text(
                                "New Chat",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: _startNewChat,
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                'assets/images/Document_Text.svg',
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                              title: Text(
                                "History",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: _refreshChatHistoryList,
                            ),
                            ListTile(
                              leading: SvgPicture.asset(
                                'assets/images/Heart_Angle.svg',
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Preferred message",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {},
                            ),
                            SizedBox(height: 20),
                            Text(
                              'History:',
                              style: TextStyle(color: Colors.white70),
                            ),
                            ..._filteredChatHistory.map((history) {
                              return ListTile(
                                title: Text(
                                  history,
                                  style: TextStyle(color: Colors.white),
                                ),
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
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/images/user.png",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
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
