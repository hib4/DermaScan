import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/cubit/scan_history_cubit.dart';
import '../core/cubit/scan_history_states.dart';
import '../core/models/scan_model.dart';
import '../core/extensions/navigator_extensions.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/history_item.dart';
import '../widgets/secondary_button.dart';
import 'results_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScanHistoryCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScanHistoryCubit, ScanHistoryState>(
        builder: (context, state) {
          if (state is ScanHistoryLoading || state is ScanHistoryInitial) {
            return Center(
              child: CupertinoActivityIndicator(
                color: AppColors.primaryInteractive(context),
              ),
            );
          }
          if (state is ScanHistoryError) return _buildErrorState(state.message);
          if (state is ScanHistoryLoaded) {
            if (state.scans.isEmpty) return _buildEmptyState();
            return _buildScanList(state.scans);
          }
          return Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primaryInteractive(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScanList(List<ScanModel> scans) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () => context.read<ScanHistoryCubit>().loadHistory(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          24,
          26 + MediaQuery.paddingOf(context).top,
          24,
          110 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text('History', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(
            'Previous screenings appear in reverse chronological order.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.mutedText(context),
            ),
          ),
          const SizedBox(height: 24),
          ...scans.map(
            (scan) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HistoryItem(
                scan: scan,
                onTap: () => context.push(ResultsScreen(scan: scan)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: CupertinoIcons.clock,
      title: 'No scans yet',
      message:
          'Your saved screening history will appear here after your first scan.',
      actionLabel: 'Refresh',
      onAction: () => context.read<ScanHistoryCubit>().loadHistory(),
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            size: 48,
            color: AppColors.accentRed,
          ),
          const SizedBox(height: 16),
          Text('Failed to load history', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            text: 'Retry',
            onPressed: () => context.read<ScanHistoryCubit>().loadHistory(),
          ),
        ],
      ),
    );
  }
}
