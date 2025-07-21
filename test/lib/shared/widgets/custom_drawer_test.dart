import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:insurance_company/shared/widgets/custom_drawer.dart';

void main() {
  testWidgets('Drawer displays main items', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        drawer: CustomDrawer(),
      ),
    ));

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();


    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget); 
  });
}
