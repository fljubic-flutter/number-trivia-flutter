import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:tdd_number_trivia/core/error/failure.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> execute({@required int number}) async =>
      await repository.getConcreteNumberTrivia(number);
}
