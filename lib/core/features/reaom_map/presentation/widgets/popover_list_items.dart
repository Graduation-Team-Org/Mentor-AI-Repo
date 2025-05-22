import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/preferred_messages_cubit/preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class ListItems extends StatefulWidget {
  const ListItems({super.key});

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  bool isLiked = false;

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
              onPressed: () {},
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
              onPressed: () {
                setState(() {
                  isLiked = !isLiked;
                });
                
                // Use a safer way to access the cubit
                if (isLiked) {
                  try {
                    // Use context.read instead of BlocProvider.of
                    final cubit = context.read<PreferredMessagesCubit>();
                    // You can add additional logic here if needed
                    print("Successfully accessed PreferredMessagesCubit");
                  } catch (e) {
                    print('Error accessing PreferredMessagesCubit: $e');
                    // The UI state will still update even if the cubit access fails
                  }
                }
              },
              icon: Row(
                children: [
                  SvgPicture.asset(
                    isLiked ? 'assets/images/solid_heart_angle.svg' :'assets/images/Heart_Angle.svg',
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
                      color: Colors.white,
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
