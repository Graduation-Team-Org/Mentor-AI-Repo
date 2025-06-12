import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareRoadMapChatScreen {
  // Generate a shareable link for the conversation
  static Future<void> shareConversation(
      BuildContext context, List<ChatMessageModel> messages) async {
    try {
      // Create a formatted text representation of the conversation
      final String formattedConversation = _formatConversation(messages);
      
      // Generate a unique ID for this conversation
      final String conversationId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create a shareable link
      final String baseUrl = dotenv.env['APP_BASE_URL'] ?? 'https://roadmapmentor.app';
      final String shareableLink = '$baseUrl/shared-chat/$conversationId';
      
      // Store the conversation data (in a real app, this would be in a database)
      // For now, we'll just copy the formatted text to clipboard
      await Clipboard.setData(ClipboardData(text: formattedConversation));
      
      // Show a dialog with sharing options
      await _showSharingDialog(context, shareableLink, formattedConversation);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing conversation: $e')),
      );
    }
  }
  
  // Format the conversation for sharing
  static String _formatConversation(List<ChatMessageModel> messages) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('Road Map Mentor Conversation');
    buffer.writeln('----------------------------');
    buffer.writeln();
    
    for (var message in messages) {
      final sender = message.isUser ? 'You' : message.senderName;
      buffer.writeln('$sender:');
      buffer.writeln(message.content);
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  // Show a dialog with sharing options
  static Future<void> _showSharingDialog(
      BuildContext context, String link, String formattedText) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Conversation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Choose how you want to share this conversation:'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Share.share(
                      'Check out this Road Map Mentor conversation: $link\n\n$formattedText',
                      subject: 'Road Map Mentor Conversation',
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Share Link and Text'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Share.share(
                      'Check out this Road Map Mentor conversation: $link',
                      subject: 'Road Map Mentor Conversation',
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Share Link Only'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: link));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied to clipboard')),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Copy Link to Clipboard'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  // Open a shared conversation (to be implemented in your navigation system)
  static Future<void> openSharedConversation(String conversationId) async {
    // In a real app, you would fetch the conversation data from your backend
    // For now, we'll just show a placeholder implementation
    
    // This would be replaced with actual navigation to a read-only chat screen
    final Uri url = Uri.parse('https://roadmapmentor.app/shared-chat/$conversationId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}