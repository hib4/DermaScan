import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/extensions/navigator_extensions.dart';
import '../../routes/app_router.dart';
import '../results_screen.dart';
import '../../core/cubit/scan_cubit.dart';
import '../../widgets/analysis_loading_state.dart';

/// Loading screen that runs the full TFLite inference pipeline.
class ProcessingScreen extends StatefulWidget {
  final String? imagePath;

  const ProcessingScreen({super.key, this.imagePath});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _runInference();
  }

  Future<void> _runInference() async {
    if (widget.imagePath == null) {
      if (mounted) context.pushReplacement(const ShellRoute());
      return;
    }

    try {
      final cubit = context.read<ScanCubit>();
      await cubit.runInference(widget.imagePath!);

      if (!mounted) return;
      context.push(const ResultsScreen());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analysis failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
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
