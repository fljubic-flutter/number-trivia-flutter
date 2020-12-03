import 'package:dartz/dartz.dart';

import 'package:tdd_number_trivia/core/error/failure.dart';
import 'package:tdd_number_trivia/core/platform/network_info.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/repositories/number_trivia_repository.dart';

// Responsible for handling exceptions,

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  NumberTriviaRepositoryImpl({
    localDataSource,
    remoteDataSource,
    networkInfo,
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
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    return null;
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    return null;
  }
}
