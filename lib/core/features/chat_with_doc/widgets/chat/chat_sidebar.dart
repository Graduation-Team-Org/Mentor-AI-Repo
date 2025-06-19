import 'package:flutter/material.dart';

class ChatSidebar extends StatelessWidget {
  final List<String> chatHistory;
  final List<String> filteredHistory;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final Function(String) onChatSelected;
  final VoidCallback onShareChat;
  final VoidCallback onNewChat;
  final VoidCallback onClose;

  const ChatSidebar({
    Key? key,
    required this.chatHistory,
    required this.filteredHistory,
    required this.searchController,
    required this.onSearch,
    required this.onChatSelected,
    required this.onShareChat,
    required this.onNewChat,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Color(0xFF150E31),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chat History',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredHistory[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => onChatSelected(filteredHistory[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: onNewChat,
                  icon: Icon(Icons.add),
                  label: Text('New Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7B4FD0),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onShareChat,
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7B4FD0),
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
