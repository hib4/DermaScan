enum RiskLevel {
  routine('Routine', 'Track changes and review if symptoms evolve.'),
  elevated('Elevated', 'Professional evaluation is recommended.'),
  high('High', 'Please consult a certified dermatologist for proper evaluation.');

  const RiskLevel(this.label, this.nextStep);
  final String label;
  final String nextStep;
}

class ConditionInfo {
  const ConditionInfo({
    required this.label,
    required this.riskLevel,
    required this.overview,
    required this.characteristics,
    required this.riskFactors,
    required this.seekHelp,
  });

  final String label;
  final RiskLevel riskLevel;
  final String overview;
  final List<String> characteristics;
  final List<String> riskFactors;
  final String seekHelp;

  String get resultLead => 'AI screening result suggests a possible visual match.';
  String get diagnosisDisclaimer => 'This is not a medical diagnosis.';
}

class ConditionLibrary {
  ConditionLibrary._();

  static const String generalDisclaimer =
      'DermaScan is an informational screening assistant and is not a substitute for professional medical advice.';

  static const List<String> scanTips = [
    'Use bright, even lighting.',
    'Keep the skin area centered inside the frame.',
    'Hold the camera steady and avoid blurry images.',
    'Do not use filters or edit the image before scanning.',
  ];

  static const Map<String, ConditionInfo> _items = {
    'Malignant': ConditionInfo(
      label: 'Malignant',
      riskLevel: RiskLevel.high,
      overview:
          'The model suggests a possible visual match with a malignant skin lesion, such as melanoma or basal cell carcinoma. These conditions require professional medical evaluation.',
      characteristics: [
        'Asymmetry or uneven shape',
        'Irregular or poorly defined border',
        'Multiple colors or recent visual change',
        'Pearly bump, shiny lesion, or sore that does not heal',
      ],
      riskFactors: [
        'History of intense UV exposure or sunburns',
        'Family or personal history of skin cancer',
        'Many or atypical moles',
        'Fair skin or immune suppression',
      ],
      seekHelp:
          'Please consult a certified dermatologist for proper evaluation as soon as possible, especially if the lesion is changing, bleeding, or new.',
    ),
    'Pre-malignant': ConditionInfo(
      label: 'Pre-malignant',
      riskLevel: RiskLevel.elevated,
      overview:
          'The model suggests a possible visual match with a pre-malignant skin lesion, such as actinic keratosis. These areas can sometimes progress if left untreated.',
      characteristics: [
        'Rough, scaly, or sandpaper-like texture',
        'Pink, red, or tan patch',
        'Often found on sun-exposed areas (face, ears, hands)',
        'May feel dry or crusty',
      ],
      riskFactors: [
        'Frequent or prolonged UV exposure',
        'Outdoor work or recreational sun exposure',
        'Fair skin or history of sunburns',
        'Older age',
      ],
      seekHelp:
          'Professional evaluation is recommended, particularly for persistent, growing, or symptomatic patches.',
    ),
    'Benign & Common': ConditionInfo(
      label: 'Benign & Common',
      riskLevel: RiskLevel.routine,
      overview:
          'The model suggests a possible visual match with a benign skin growth or lesion, such as a mole, dermatofibroma, or benign keratosis. Most are harmless, but changes should be monitored.',
      characteristics: [
        'Often round or oval with even borders',
        'Usually uniform in color',
        'May be flat or slightly raised',
        'Can appear waxy, scaly, or stuck-on (keratosis)',
        'May dimple when pinched (dermatofibroma)',
      ],
      riskFactors: [
        'Sun exposure',
        'Genetics and family history',
        'Age-related skin changes',
        'Minor skin trauma or insect bites',
      ],
      seekHelp:
          'Seek professional advice if the lesion changes in size, shape, or color, or if it begins to itch, bleed, or become painful.',
    ),
  };

  static ConditionInfo forLabel(String label) {
    return _items[label] ??
        ConditionInfo(
          label: label,
          riskLevel: RiskLevel.routine,
          overview:
              'This category is shown as an informational visual match from the screening model.',
          characteristics: const ['Visual features can vary by person.'],
          riskFactors: const ['Risk depends on personal history and clinical context.'],
          seekHelp:
              'Consult a certified dermatologist for proper evaluation if you are concerned.',
        );
  }

  static List<ConditionInfo> get all => _items.values.toList(growable: false);
}
