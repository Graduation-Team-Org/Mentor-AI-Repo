Widget _buildServicesList(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildServiceCard(context, "Roadmap", "Talk to Steve to find out which roadmap to follow for your desired track.", "image/home1.png"),
        _buildServiceCard(context, "Chat With Document", "Talk to Serena to discuss your document in detail and get valuable insights.", "image/home2.png"),
        _buildServiceCard(context, "CV Analysis", "Talk to Marcus to review your CV and find ways to make it stronger.", "image/home3.png"),
        _buildServiceCard(context, "Interview", "Talk to David to prepare for your next big interview with confidence and expert guidance.", "image/home4.png"),
        _buildServiceCard(context, "Build CV", "Helping you create a CV tailored for the job market by guiding you on what to include", "image/home4.png"),
      ],
    );
  }
