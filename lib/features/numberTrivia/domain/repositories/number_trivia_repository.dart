import 'package:dartz/dartz.dart';
import 'package:tdd_number_trivia/core/error/failure.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';

// The implementation of a Repository is in data, but since we don't want it to be
// reliant on our data when testing, we also create an abstract implementation and
// use mockito to mock our repository in tests

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
