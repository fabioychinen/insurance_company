import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_company/shared/widgets/custom_drawer.dart';
import 'package:insurance_company/modules/home/viewmodel/home_bloc.dart';
import 'package:insurance_company/modules/home/viewmodel/home_state.dart';

class MockHomeBloc extends Mock implements HomeBloc {}

void main() {
  late MockHomeBloc mockHomeBloc;

  setUp(() {
    mockHomeBloc = MockHomeBloc();
    when(() => mockHomeBloc.state).thenReturn(HomeState());
    when(() => mockHomeBloc.stream).thenAnswer((_) => const Stream<HomeState>.empty());
  });

  testWidgets('Drawer displays main items', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeBloc>.value(
          value: mockHomeBloc,
          child: Scaffold(
            drawer: const CustomDrawer(),
            appBar: AppBar(), 
            body: const SizedBox(),
          ),
        ),
      ),
    );

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
