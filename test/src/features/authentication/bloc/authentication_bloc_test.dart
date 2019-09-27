import 'package:authentication_bloc_tdd_example/src/features/authentication/bloc/bloc.dart';
import 'package:authentication_bloc_tdd_example/src/shared/repositories/user/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

main() {
  AuthenticationBloc authenticationBloc;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    authenticationBloc = AuthenticationBloc(userRepository: mockUserRepository);
  });

  test('Should have correct initial state', () {
    expect(
      AuthenticationUninitialized(),
      authenticationBloc.initialState,
    );
  });

  test('Should not emit new states when dispose', () {
    expectLater(
      authenticationBloc.state,
      emitsInOrder([]),
    );

    authenticationBloc.dispose();
  });

  group("App started", () {
    test("Should emit [Uninitialized, Unauthenticated] when token is invalid",
        () async {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationUnauthenticated(),
      ];

      when(mockUserRepository.hasToken())
          .thenAnswer((_) => Future.value(false));

      expectLater(authenticationBloc.state, emitsInOrder(expectedResponse));

      authenticationBloc.dispatch(AppStarted());
    });
  });

  group("Logged In", () {
    test(
        "Should emit [Uninitialized, Loading, Authenticated] when token is persisted",
        () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationLoading(),
        AuthenticationAuthenticated(),
      ];

      expectLater(authenticationBloc.state, emitsInOrder(expectedResponse));

      authenticationBloc.dispatch(LoggedIn(token: "instance.token"));
    });
  });

  group("Logged Out", () {
    test(
        "Should emit [Unitialized, Loading, Unauthenticated] when token is deleted",
        () {
      final expectedResponse = [
        AuthenticationUninitialized(),
        AuthenticationLoading(),
        AuthenticationUnauthenticated(),
      ];

      expectLater(authenticationBloc.state, emitsInOrder(expectedResponse));

      authenticationBloc.dispatch(LoggedOut());
    });
  });
}
