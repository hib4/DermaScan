import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/models/condition_info.dart';
import '../theme/app_colors.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/health_info_card.dart';

class ResultDetailScreen extends StatelessWidget {
  const ResultDetailScreen({
    super.key,
    required this.condition,
  });

  final ConditionInfo condition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(condition.label),
        border: const Border(bottom: BorderSide(color: AppColors.dividerSoft)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
        children: [
          Text(condition.label, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(condition.overview, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.mute)),
          const SizedBox(height: 22),
          const DisclaimerBanner(),
          const SizedBox(height: 22),
          HealthInfoCard(
            title: 'Visual characteristics',
            body: condition.characteristics.join('\n'),
            icon: CupertinoIcons.eye,
          ),
          const SizedBox(height: 12),
          HealthInfoCard(
            title: 'Common risk factors',
            body: condition.riskFactors.join('\n'),
            icon: CupertinoIcons.list_bullet,
          ),
          const SizedBox(height: 12),
          HealthInfoCard(
            title: 'When to seek professional help',
            body: condition.seekHelp,
            icon: CupertinoIcons.heart,
          ),
        ],
      ),
    );
  }
}
