import 'package:dermascan/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SecondaryButton shows text and calls onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SecondaryButton(
            text: 'Outline',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Outline'), findsOneWidget);
    await tester.tap(find.byType(SecondaryButton));
    expect(tapped, isTrue);
  });

  testWidgets('SecondaryButton shows loading spinner when isLoading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SecondaryButton(
            text: 'Loading',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
