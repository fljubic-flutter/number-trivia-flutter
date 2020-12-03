import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia/core/error/exceptions.dart';
import 'package:tdd_number_trivia/core/error/failure.dart';
import 'package:tdd_number_trivia/core/platform/network_info.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/models/number_trivia_model.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';

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

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final NumberTriviaModel testNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test(
      'should check if the device is online',
      () {
        when(networkInfo.isConnected).thenAnswer((_) async => true);

        repository.getConcreteNumberTrivia(testNumber);

        verify(networkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data if the remote data source call is successfull',
        () async {
          when(remoteDataSource.getConcreteNumberTrivia(testNumber))
              .thenAnswer((_) async => testNumberTriviaModel);

          final result = await repository.getConcreteNumberTrivia(testNumber);

          verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
          expect(result, Right(testNumberTrivia)); // mozda mi fali equals ovdje
        },
      );

      test(
        'should cache data locally when call to remote is successfull',
        () async {
          when(remoteDataSource.getConcreteNumberTrivia(testNumber))
              .thenAnswer((_) async => testNumberTriviaModel);

          await repository.getConcreteNumberTrivia(testNumber);

          verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
          verify(localDataSource.cacheNumberTrivia(testNumberTrivia));
        },
      );

      test(
        'should convert ServerException to ServerFailure and not cache locally',
        () async {
          when(remoteDataSource.getConcreteNumberTrivia(testNumber))
              .thenThrow(ServerException());

          final result = await repository.getConcreteNumberTrivia(testNumber);

          expect(result, Left(ServerFailure()));
          verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
          verifyZeroInteractions(localDataSource);
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should get cached number trivia when cached data is present',
        () async {
          when(localDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);

          final result = await repository.getConcreteNumberTrivia(testNumber);

          expect(result, Right(testNumberTrivia));
          verify(localDataSource.getLastNumberTrivia());
          verifyZeroInteractions(remoteDataSource);
        },
      );

      test(
        'should convert CacheException to CacheFailure if no data is cached',
        () async {
          when(localDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          final result = await repository.getConcreteNumberTrivia(testNumber);

          expect(result, Left(CacheFailure()));
          verify(localDataSource.getLastNumberTrivia());
          verifyZeroInteractions(remoteDataSource);
        },
      );
    });
  });
}
