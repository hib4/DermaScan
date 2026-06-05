import 'package:dermascan/core/models/condition_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConditionLibrary', () {
    test('maps Melanoma to high risk next step', () {
      final info = ConditionLibrary.forLabel('Melanoma');

      expect(info.riskLevel, RiskLevel.high);
      expect(
        info.riskLevel.nextStep,
        contains('consult a certified dermatologist'),
      );
    });

    test('returns fallback metadata for unknown labels', () {
      final info = ConditionLibrary.forLabel('Unknown');

      expect(info.label, 'Unknown');
      expect(info.riskLevel, RiskLevel.routine);
      expect(info.diagnosisDisclaimer, 'This is not a medical diagnosis.');
    });
  });
}
