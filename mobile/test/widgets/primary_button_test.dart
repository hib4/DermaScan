import 'package:dermascan/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrimaryButton shows text and calls onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: 'Tap me',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Tap me'), findsOneWidget);
    await tester.tap(find.byType(PrimaryButton));
    expect(tapped, isTrue);
  });

  testWidgets('PrimaryButton shows loading spinner when isLoading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: 'Loading',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsNothing);
  });

  testWidgets('PrimaryButton is disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: 'Disabled',
            onPressed: null,
          ),
        ),
      ),
    );

    final widget = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(widget.onPressed, isNull);
  });
}
