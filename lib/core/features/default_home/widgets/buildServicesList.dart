import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/default_home/widgets/buildServiceCard.dart';

Widget _buildServicesList(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        buildServiceCard(context, "Roadmap", "Talk to Steve to find out which roadmap to follow for your desired track.", "image/home1.png"),
        buildServiceCard(context, "Chat With Document", "Talk to Serena to discuss your document in detail and get valuable insights.", "image/home2.png"),
        buildServiceCard(context, "CV Analysis", "Talk to Marcus to review your CV and find ways to make it stronger.", "image/home3.png"),
        buildServiceCard(context, "Interview", "Talk to David to prepare for your next big interview with confidence and expert guidance.", "image/home4.png"),
        buildServiceCard(context, "Build CV", "Helping you create a CV tailored for the job market by guiding you on what to include", "image/home4.png"),
      ],
    );
  }
