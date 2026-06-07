import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/extensions/navigator_extensions.dart';
import '../../core/utils/app_logger.dart';
import '../../routes/app_router.dart';
import '../results_screen.dart';
import '../../core/cubit/scan_cubit.dart';
import '../../widgets/analysis_loading_state.dart';
import '../../widgets/app_toast.dart';

/// Loading screen that runs the full TFLite inference pipeline.
class ProcessingScreen extends StatefulWidget {
  final String? imagePath;

  const ProcessingScreen({super.key, this.imagePath});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  final _logger = AppLogger.scan;

  @override
  void initState() {
    super.initState();
    _runInference();
  }

  Future<void> _runInference() async {
    if (widget.imagePath == null) {
      _logger.w('ProcessingScreen opened without image path, redirecting to home');
      if (mounted) context.pushReplacement(const ShellRoute());
      return;
    }

    _logger.i('ProcessingScreen: running inference for ${widget.imagePath!.split('/').last}');

    try {
      final cubit = context.read<ScanCubit>();
      await cubit.runInference(widget.imagePath!);

      if (!mounted) return;
      _logger.i('ProcessingScreen: inference complete, navigating to results');
      context.pushReplacement(const ResultsScreen());
    } catch (e, st) {
      if (!mounted) return;
      _logger.e('ProcessingScreen: inference threw exception', error: e, stackTrace: st);
      showAppToast(context, 'Analysis failed: $e', isError: true);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnalysisLoadingState(),
      ),
    );
  }
}
