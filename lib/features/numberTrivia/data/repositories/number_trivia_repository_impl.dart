import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:tdd_number_trivia/core/error/exceptions.dart';

import 'package:tdd_number_trivia/core/error/failure.dart';
import 'package:tdd_number_trivia/core/platform/network_info.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/repositories/number_trivia_repository.dart';

// Responsible for handling exceptions,

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

  NumberTriviaLocalDataSource get localDataSource => _localDataSource;
  NumberTriviaRemoteDataSource get remoteDataSource => _remoteDataSource;
  NetworkInfo get networkInfo => _networkInfo;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    bool isConnected = await _networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteTrivia =
            await _remoteDataSource.getConcreteNumberTrivia(number);
        _localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await _localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    return null;
  }
}
