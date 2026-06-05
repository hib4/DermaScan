import 'package:flutter/material.dart';
import '../core/extensions/navigator_extensions.dart';
import '../core/models/condition_info.dart';
import '../theme/app_colors.dart';
import '../widgets/health_info_card.dart';
import 'result_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conditions = ConditionLibrary.all
        .where((item) => item.label.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 34),
          children: [
            Text('Learn', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Educational skin health information, written for screening context rather than diagnosis.',
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.mute),
            ),
            const SizedBox(height: 24),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Search conditions',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 24),
            HealthInfoCard(
              icon: Icons.wb_sunny_outlined,
              title: 'Clear photo checklist',
              body: ConditionLibrary.scanTips.join(' '),
            ),
            const SizedBox(height: 18),
            Text('Condition guide', style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            ...conditions.map(
              (condition) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HealthInfoCard(
                  title: condition.label,
                  body: '${condition.riskLevel.label} urgency. ${condition.overview}',
                  onTap: () => context.push(ResultDetailScreen(condition: condition)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
