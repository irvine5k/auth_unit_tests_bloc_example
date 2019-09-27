import 'package:authentication_bloc_tdd_example/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:authentication_bloc_tdd_example/src/features/authentication/bloc/authentication_state.dart';
import 'package:authentication_bloc_tdd_example/src/features/authentication/bloc/bloc.dart';
import 'package:authentication_bloc_tdd_example/src/features/login/bloc/bloc.dart';
import 'package:authentication_bloc_tdd_example/src/features/login/bloc/login_bloc.dart';
import 'package:authentication_bloc_tdd_example/src/features/login/bloc/login_state.dart';
import 'package:authentication_bloc_tdd_example/src/shared/repositories/user/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

main() {
  LoginBloc loginBloc;
  MockUserRepository userRepository;
  MockAuthenticationBloc authenticationBloc;

  setUp(() {
    userRepository = MockUserRepository();
    authenticationBloc = MockAuthenticationBloc();
    loginBloc = LoginBloc(
      userRepository: userRepository,
      authenticationBloc: authenticationBloc,
    );
  });

  test('Should have correct initial state', () {
    expect(
      LoginInitial(),
      loginBloc.initialState,
    );
  });

  test('Should not emit new states when dispose', () {
    expectLater(
      loginBloc.state,
      emitsInOrder([]),
    );

    loginBloc.dispose();
  });

  group('LoginButtonPressed', () {
    test('emits token on success', () {
      final expectedResponse = [
        LoginInitial(),
        LoginLoading(),
        LoginInitial(),
      ];

      when(userRepository.authenticate(
        username: 'valid.username',
        password: 'valid.password',
      )).thenAnswer((_) => Future.value('token'));

      expectLater(
        loginBloc.state,
        emitsInOrder(expectedResponse),
      ).then((_) {
        verify(authenticationBloc.dispatch(LoggedIn(token: 'token'))).called(1);
      });

      loginBloc.dispatch(LoginButtonPressed(
        email: 'valid.username',
        password: 'valid.password',
      ));
    });
  });
}
