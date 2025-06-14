import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/chat_message.dart';
import '../../utils/chat_utils.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/chat_sidebar.dart';
import '../../services/chat_sharing_service.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  List<String> _chatHistory = [];
  List<String> _filteredHistory = [];
  String _currentConversation = '';
  bool _isLoading = false;
  bool _showSidebar = true;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    _chatHistory = await ChatUtils.getChatHistory();
    setState(() {
      _filteredHistory = _chatHistory;
    });
  }

  void _startNewChat() {
    setState(() {
      _messages = [];
      _currentConversation = ''; // Will be set when first message is sent
    });
  }

  Future<void> _loadConversation(String conversationName) async {
    setState(() {
      _isLoading = true;
    });

    final messages = await ChatUtils.loadConversation(conversationName);
    setState(() {
      _messages = messages;
      _currentConversation = conversationName;
      _isLoading = false;
    });
  }

  Future<void> _saveConversation() async {
    if (_messages.isEmpty) return;

    await ChatUtils.saveConversation(_currentConversation, _messages);
    if (!_chatHistory.contains(_currentConversation)) {
      _chatHistory.add(_currentConversation);
      await ChatUtils.saveChatHistory(_chatHistory);
      setState(() {
        _filteredHistory = _chatHistory;
      });
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _filteredHistory = _chatHistory
          .where(
            (history) => history.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  Future<void> _handleFilePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      // Handle the picked file
      // You can add the file to the chat or process it as needed
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      from: 'User',
      text: _messageController.text.trim(),
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    // If this is the first message, use it to name the conversation
    if (_currentConversation.isEmpty) {
      _currentConversation = ChatUtils.generateConversationName(message.text);
    }

    _saveConversation();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _shareChat() async {
    if (_messages.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No messages to share')));
      return;
    }

    try {
      setState(() => _isLoading = true);
      final shareUrl = await ChatSharingService.shareChat(_messages);
      setState(() => _isLoading = false);

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
      setState(() => _isLoading = false);
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sharing chat: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF110A2B),
      body: Row(
        children: [
          if (_showSidebar)
            ChatSidebar(
              chatHistory: _chatHistory,
              filteredHistory: _filteredHistory,
              searchController: _searchController,
              onSearch: _handleSearch,
              onChatSelected: _loadConversation,
              onShareChat: _shareChat,
              onNewChat: _startNewChat,
              onClose: () {
                setState(() {
                  _showSidebar = false;
                });
              },
            ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      if (!_showSidebar)
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _showSidebar = true;
                            });
                          },
                        ),
                      Expanded(
                        child: Text(
                          _currentConversation.isEmpty
                              ? 'New Chat'
                              : _currentConversation,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/fi_share-2.svg',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                        onPressed: _shareChat,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(message: _messages[index]);
                          },
                        ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/fi_paperclip.svg',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                        onPressed: _handleFilePick,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
