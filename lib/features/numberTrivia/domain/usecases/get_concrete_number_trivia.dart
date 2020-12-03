import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:tdd_number_trivia/core/error/failure.dart';
import 'package:tdd_number_trivia/core/usecases/usecase.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  // Instead of GetConcreteNumberTrivia().call(num), we can just use GetConcreteNumberTrivia(num)
  // this way we can use the class as a function-ish

  Future<Either<Failure, NumberTrivia>> call(Params param) async =>
      await repository.getConcreteNumberTrivia(param.number);
}

class Params extends Equatable {
  final int number;
  Params({
    @required this.number,
  });

  @override
  List<Object> get props => [number];
}
