import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/get_all_preferred_mesages_cubit/get_all_preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/preferred/preferred_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/preferred_messages_cubit/preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';
import 'package:flutter/services.dart'; // Add this import for clipboard functionality

class ListItems extends StatefulWidget {
  final String messageContent;
  final String senderAvatar;

  const ListItems({
    super.key,
    required this.messageContent,
    required this.senderAvatar,
  });

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  bool isLiked = false;
  int? messageIndex;

  @override
  void initState() {
    super.initState();
    // Check if this message is already in preferred messages
    _checkIfMessageIsLiked();
  }

  void _checkIfMessageIsLiked() {
    try {
      final getAllPreferredMessagesCubit =
          context.read<GetAllPreferredMessagesCubit>();
      final preferredMessages =
          getAllPreferredMessagesCubit.preferredMessages ?? [];

      for (int i = 0; i < preferredMessages.length; i++) {
        if (preferredMessages[i].msgContent == widget.messageContent) {
          setState(() {
            isLiked = true;
            messageIndex = i;
          });
          break;
        }
      }
    } catch (e) {
      print('Error checking if message is liked: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkPerple.withValues(alpha: 0.7), // Dark background
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListView(
          padding: const EdgeInsets.all(2),
          children: [
            IconButton(
              onPressed: () async {
                // Copy the message content to clipboard
                await Clipboard.setData(ClipboardData(text: widget.messageContent));
                
                // Show a snackbar or toast to indicate successful copy
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                
                // Close the popover after copying
                Navigator.of(context).pop();
              },
              icon: Row(
                children: [
                  const Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Copy',
                    style: body.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                setState(() {
                  isLiked = !isLiked;
                });

                try {
                  final preferredMessagesCubit =
                      context.read<PreferredMessagesCubit>();
                  final getAllPreferredMessagesCubit =
                      context.read<GetAllPreferredMessagesCubit>();

                  if (isLiked) {
                    // Add to preferred messages
                    final preferredMessage = PreferredMessagesModel(
                      msgContent: widget.messageContent,
                      msgImage: widget.senderAvatar,
                      likeDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                    );

                    // Use await to ensure the operation completes
                    await preferredMessagesCubit
                        .addPrefrredMessages(preferredMessage);
                    
                    // Refresh the list after adding
                    getAllPreferredMessagesCubit.fetchAllMessages();

                    print("Message added to preferred messages");
                  } else if (messageIndex != null) {
                    // Remove from preferred messages
                    // Use await to ensure the operation completes
                    await preferredMessagesCubit
                        .removePreferredMessage(messageIndex!);
                    
                    // Refresh the list after removing
                    getAllPreferredMessagesCubit.fetchAllMessages();

                    print("Message removed from preferred messages");
                  }

                  // Close the popover after action
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error with preferred messages operation: $e');
                }
              },
              icon: Row(
                children: [
                  SvgPicture.asset(
                    isLiked
                        ? 'assets/images/solid_heart_angle.svg'
                        : 'assets/images/Heart_Angle.svg',
                    width: 15,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    isLiked ? 'Liked' : 'Like',
                    style: body.copyWith(
                      fontSize: 12,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/Share.svg',
                    width: 15,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Share',
                    style: body.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/Trash_Bin_Minimalistic.svg',
                    width: 15,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Delete',
                    style: body.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
