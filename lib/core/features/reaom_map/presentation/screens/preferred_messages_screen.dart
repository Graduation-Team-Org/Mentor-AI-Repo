import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';
import 'package:road_map_mentor/core/utils/widgets/back_button.dart';

class PreferredMessagesScreen extends StatelessWidget {
  const PreferredMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackButton(),
      ),
      body: Scaffold(
        body: Stack(
          children: [
            AppViewColor(),
          ],
        ),
      ),
    );
  }
}