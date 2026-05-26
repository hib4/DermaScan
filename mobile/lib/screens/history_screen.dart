import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/cubit/scan_history_cubit.dart';
import '../core/cubit/scan_history_states.dart';
import '../core/models/scan_model.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_card.dart';

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
      body: SafeArea(
        child: BlocBuilder<ScanHistoryCubit, ScanHistoryState>(
          builder: (context, state) {
            if (state is ScanHistoryLoading || state is ScanHistoryInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ScanHistoryError) return _buildErrorState(state.message);
            if (state is ScanHistoryLoaded) {
              if (state.scans.isEmpty) return _buildEmptyState();
              return _buildScanList(state.scans);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildScanList(List<ScanModel> scans) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () => context.read<ScanHistoryCubit>().loadHistory(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: scans.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final scan = scans[index];
          return CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scan.classification,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(scan.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(scan.confidence * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_outlined, size: 64, color: AppColors.mute),
          const SizedBox(height: 16),
          Text(
            'No scans yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.bodyMid,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your scan history will appear here',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.muteSoft,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.accentRed),
          const SizedBox(height: 16),
          Text(
            'Failed to load history',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.read<ScanHistoryCubit>().loadHistory(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
