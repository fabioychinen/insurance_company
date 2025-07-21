import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:insurance_company/app/core/constants/app_strings.dart';
import 'package:insurance_company/modules/family/view/family_page.dart';
import 'package:insurance_company/modules/home/view/home_page.dart';
import 'package:insurance_company/modules/home/viewmodel/home_bloc.dart';
import 'package:insurance_company/modules/home/viewmodel/home_state.dart';

import '../viewmodel/home_bloc_test.dart';

class MockHomeBloc extends Mock implements HomeBloc {}

void main() {
  late MockHomeBloc mockHomeBloc;
  late MockFirebaseRepositoryImpl mockRepository;

  setUp(() {
    mockRepository = MockFirebaseRepositoryImpl();
    mockHomeBloc = MockHomeBloc();

    registerFallbackValue(const HomeState());
  });

  testWidgets('HomePage displays user header and sections', (tester) async {
    when(() => mockHomeBloc.state).thenReturn(const HomeState(userName: 'Test User'));
    whenListen(
      mockHomeBloc,
      Stream<HomeState>.fromIterable([
        const HomeState(userName: 'Test User'),
      ]),
      initialState: const HomeState(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeBloc>.value(
          value: mockHomeBloc,
          child: const HomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text(AppStrings.quoteAndHire), findsOneWidget);
    expect(find.text(AppStrings.family), findsOneWidget);
    expect(find.text(AppStrings.contracted), findsOneWidget);
  });

  testWidgets('HomePage navigates to FamilyPage when "Add Family" is tapped', (tester) async {
    when(() => mockHomeBloc.state).thenReturn(const HomeState());
    whenListen(
      mockHomeBloc,
      Stream<HomeState>.fromIterable([const HomeState()]),
      initialState: const HomeState(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeBloc>.value(
          value: mockHomeBloc,
          child: const HomePage(),
        ),
      ),
    );

    await tester.tap(find.text(AppStrings.addFamilyHere));
    await tester.pumpAndSettle();

    expect(find.byType(FamilyPage), findsOneWidget);
  });
}