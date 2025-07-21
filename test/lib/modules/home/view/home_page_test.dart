import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:insurance_company/app/core/constants/app_strings.dart';
import 'package:insurance_company/modules/family/view/family_page.dart';
import 'package:insurance_company/modules/home/view/home_page.dart';
import 'package:insurance_company/modules/home/viewmodel/home_bloc.dart';
import 'package:insurance_company/app/core/repositories/firebase_repository_impl.dart';


class MockFirebaseRepositoryImpl extends Mock implements FirebaseRepositoryImpl {}

void main() {
  late MockFirebaseRepositoryImpl mockRepository;

  setUp(() {
    mockRepository = MockFirebaseRepositoryImpl();

    when(() => mockRepository.currentUser).thenReturn(null);

  });

  testWidgets('HomePage displays user header and sections', (tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(mockRepository),
          child: const HomePage(),
        ),
      ),
    );

    expect(find.textContaining('Test User'), findsWidgets);
    expect(find.text(AppStrings.quoteAndHire), findsOneWidget);
    expect(find.text(AppStrings.family), findsOneWidget);
    expect(find.text(AppStrings.contracted), findsOneWidget);
  });

  testWidgets('HomePage navigates to FamilyPage when "Add Family" is tapped', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(mockRepository),
          child: const HomePage(),
        ),
      ),
    );

    await tester.tap(find.text(AppStrings.addFamilyHere));
    await tester.pumpAndSettle();

    expect(find.byType(FamilyPage), findsOneWidget);
  });
}