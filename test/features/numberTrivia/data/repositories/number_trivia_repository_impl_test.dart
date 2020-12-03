import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia/core/platform/network_info.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/repositories/number_trivia_repository.dart';

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockNumberTriviaLocalDataSource localDataSource;
  MockNumberTriviaRemoteDataSource remoteDataSource;
  MockNetworkInfo networkInfo;
  NumberTriviaRepositoryImpl repository;

  setUp(() {
    localDataSource = MockNumberTriviaLocalDataSource();
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });
}
