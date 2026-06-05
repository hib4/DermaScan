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
    'Melanoma': ConditionInfo(
      label: 'Melanoma',
      riskLevel: RiskLevel.high,
      overview:
          'Melanoma is a serious skin cancer that can resemble changing or irregular pigmented lesions.',
      characteristics: [
        'Asymmetry or uneven shape',
        'Irregular border',
        'Multiple colors or recent visual change',
      ],
      riskFactors: [
        'History of intense UV exposure',
        'Family history of melanoma',
        'Many or atypical moles',
      ],
      seekHelp:
          'Please consult a certified dermatologist for proper evaluation, especially if the spot is changing, bleeding, or new.',
    ),
    'Melanocytic Nevus': ConditionInfo(
      label: 'Melanocytic Nevus',
      riskLevel: RiskLevel.routine,
      overview:
          'A melanocytic nevus is commonly called a mole. Many are harmless, but changes should be monitored.',
      characteristics: [
        'Often round or oval',
        'Usually even in color',
        'Can be flat or raised',
      ],
      riskFactors: [
        'Sun exposure',
        'Genetics',
        'Large number of moles',
      ],
      seekHelp:
          'Seek professional advice if it changes in size, shape, color, or begins to itch, bleed, or hurt.',
    ),
    'Basal Cell Carcinoma': ConditionInfo(
      label: 'Basal Cell Carcinoma',
      riskLevel: RiskLevel.elevated,
      overview:
          'Basal cell carcinoma is a common skin cancer that often develops on sun-exposed skin.',
      characteristics: [
        'Pearly or shiny bump',
        'Pink or reddish patch',
        'Sore that heals and returns',
      ],
      riskFactors: [
        'Long-term sun exposure',
        'Fair skin',
        'Older age or prior skin cancer',
      ],
      seekHelp:
          'A certified dermatologist can evaluate the area and discuss appropriate care.',
    ),
    'Actinic Keratosis': ConditionInfo(
      label: 'Actinic Keratosis',
      riskLevel: RiskLevel.elevated,
      overview:
          'Actinic keratosis is a rough, sun-damaged area that can sometimes progress if untreated.',
      characteristics: [
        'Rough or scaly texture',
        'Pink, red, or tan patch',
        'Often feels dry or sandpaper-like',
      ],
      riskFactors: [
        'Frequent UV exposure',
        'Outdoor work or activities',
        'Fair skin or immune suppression',
      ],
      seekHelp:
          'Professional evaluation is recommended, particularly for persistent or growing patches.',
    ),
    'Benign Keratosis': ConditionInfo(
      label: 'Benign Keratosis',
      riskLevel: RiskLevel.routine,
      overview:
          'Benign keratoses are non-cancerous growths that can vary in color and texture.',
      characteristics: [
        'Waxy, scaly, or stuck-on appearance',
        'Tan, brown, or dark color',
        'May be slightly raised',
      ],
      riskFactors: [
        'Age',
        'Genetics',
        'Sun exposure',
      ],
      seekHelp:
          'Consult a clinician if the lesion changes quickly, bleeds, or becomes painful.',
    ),
    'Dermatofibroma': ConditionInfo(
      label: 'Dermatofibroma',
      riskLevel: RiskLevel.routine,
      overview:
          'Dermatofibromas are usually firm, benign skin bumps that can appear after minor skin injury.',
      characteristics: [
        'Firm small bump',
        'Often brown, pink, or reddish',
        'May dimple when pinched',
      ],
      riskFactors: [
        'Minor skin trauma',
        'Insect bites',
        'More common in adults',
      ],
      seekHelp:
          'Seek professional care if it grows, bleeds, or looks different from nearby skin spots.',
    ),
    'Vascular Lesion': ConditionInfo(
      label: 'Vascular Lesion',
      riskLevel: RiskLevel.routine,
      overview:
          'Vascular lesions involve visible blood vessels and are often benign, though appearance can vary.',
      characteristics: [
        'Red, purple, or blue tone',
        'May blanch under pressure',
        'Can be flat or raised',
      ],
      riskFactors: [
        'Age',
        'Genetics',
        'Skin injury or sun exposure',
      ],
      seekHelp:
          'Consult a dermatologist if it changes, bleeds, or appears suddenly with other symptoms.',
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
