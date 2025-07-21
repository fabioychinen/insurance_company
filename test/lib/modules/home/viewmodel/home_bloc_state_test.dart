import 'package:flutter_test/flutter_test.dart';
import 'package:insurance_company/modules/home/viewmodel/home_state.dart';

void main() {
  test('HomeState copyWith returns a new object with updated values', () {
    const state = HomeState(userName: 'Old', userEmail: 'old@email.com');
    final newState = state.copyWith(userName: 'New', userEmail: 'new@email.com');

    expect(newState.userName, 'New');
    expect(newState.userEmail, 'new@email.com');
    expect(newState.familyMembers, state.familyMembers);
    expect(newState != state, isTrue);
  });

  test('HomeState equality works with Equatable', () {
    const state1 = HomeState(userName: 'Test');
    const state2 = HomeState(userName: 'Test');

    expect(state1, equals(state2));
  });
}
