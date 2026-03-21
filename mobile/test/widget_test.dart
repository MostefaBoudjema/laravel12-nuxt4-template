import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/src/app.dart';

void main() {
  testWidgets('app boots and shows loader first', (WidgetTester tester) async {
    await tester.pumpWidget(const SaasMobileApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
