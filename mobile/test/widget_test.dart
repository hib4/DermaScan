import 'package:dermascan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders DermaScanApp with MaterialApp.router', (tester) async {
    await tester.pumpWidget(const DermaScanApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
