import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia/core/network/network_info_impl.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker dataConnectionChecker;

  setUp(() {
    dataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(dataConnectionChecker);
  });

  test('should check connection by using DataConnectionChecker.hasConnection',
      () {
    final testHasConnectionFuture = Future.value(true);

    when(dataConnectionChecker.hasConnection)
        .thenAnswer((_) => testHasConnectionFuture);

    final result = networkInfo.isConnected;

    verify(dataConnectionChecker.hasConnection);
    expect(result, testHasConnectionFuture);
  });
}
