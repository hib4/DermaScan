class ImageQualityResult {
  const ImageQualityResult({
    required this.isAcceptable,
    this.message,
  });

  final bool isAcceptable;
  final String? message;
}
