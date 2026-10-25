import 'package:flutter/material.dart';

import '../../../presentation/widgets/coming_soon_banner.dart';

class RecommendedVisitsWidget extends StatelessWidget {
  const RecommendedVisitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonBanner(
      feature: 'Smart visit suggestions coming soon',
      icon: Icons.auto_awesome,
    );
  }
}
