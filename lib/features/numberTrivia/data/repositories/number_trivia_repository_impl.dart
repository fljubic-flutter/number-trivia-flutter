import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:tdd_number_trivia/core/error/exceptions.dart';

import 'package:tdd_number_trivia/core/error/failure.dart';
import 'package:tdd_number_trivia/core/network/network_info.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/repositories/number_trivia_repository.dart';

// Since implementations of both methods are basically the same

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

// Responsible for handling exceptions

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  NumberTriviaRepositoryImpl({
    @required localDataSource,
    @required remoteDataSource,
    @required networkInfo,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  final NumberTriviaLocalDataSource _localDataSource;
  final NumberTriviaRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getNumberTrivia(
        () async => await _remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getNumberTrivia(
        () async => await _remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    bool isConnected = await _networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteNumberTrivia = await getConcreteOrRandom();
        _localDataSource.cacheNumberTrivia(remoteNumberTrivia);
        return Right(remoteNumberTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localNumberTrivia = await _localDataSource.getLastNumberTrivia();
        return Right(localNumberTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
