import 'package:dermascan/theme/app_colors.dart';
import 'package:dermascan/theme/app_theme.dart';
import 'package:dermascan/widgets/custom_text_field.dart';
import 'package:dermascan/widgets/health_info_card.dart';
import 'package:dermascan/widgets/secondary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget darkApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: child),
    );
  }

  testWidgets('SecondaryButton uses dark surface and on-dark action color', (
    tester,
  ) async {
    await tester.pumpWidget(
      darkApp(SecondaryButton(text: 'Outline', onPressed: () {})),
    );

    final decoration = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(SecondaryButton),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((decoration) => decoration.color == AppColors.darkSurface);
    final text = tester.widget<Text>(find.text('Outline'));

    expect(decoration.color, AppColors.darkSurface);
    expect(decoration.border?.top.color, AppColors.darkHairline);
    expect(text.style?.color, AppColors.primaryOnDark);
  });

  testWidgets('CustomTextField uses dark input fill and readable text', (
    tester,
  ) async {
    await tester.pumpWidget(
      darkApp(
        const CustomTextField(labelText: 'Email', hintText: 'name@example.com'),
      ),
    );

    final field = tester.widget<CupertinoTextField>(
      find.byType(CupertinoTextField),
    );
    final decoration = field.decoration as BoxDecoration;

    expect(decoration.color, AppColors.darkSurface);
    expect(decoration.border?.top.color, AppColors.darkHairline);
    expect(field.style?.color, AppColors.darkBody);
    expect(field.placeholderStyle?.color, AppColors.darkMuteSoft);
  });

  testWidgets('HealthInfoCard uses dark elevated surface and muted body text', (
    tester,
  ) async {
    await tester.pumpWidget(
      darkApp(
        const HealthInfoCard(
          icon: CupertinoIcons.heart,
          title: 'Recommended next steps',
          body: 'Consult a certified dermatologist if you are concerned.',
        ),
      ),
    );

    final decoration =
        tester
                .widget<Container>(
                  find.descendant(
                    of: find.byType(HealthInfoCard),
                    matching: find.byType(Container),
                  ),
                )
                .decoration
            as BoxDecoration;
    final icon = tester.widget<Icon>(find.byIcon(CupertinoIcons.heart));
    final body = tester.widget<Text>(
      find.text('Consult a certified dermatologist if you are concerned.'),
    );

    expect(decoration.color, AppColors.surfaceTile1);
    expect(decoration.border?.top.color, AppColors.darkHairline);
    expect(icon.color, AppColors.primaryOnDark);
    expect(body.style?.color, AppColors.darkBodyMid);
  });
}
