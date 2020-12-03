import 'package:tdd_number_trivia/features/numberTrivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  // Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes

  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  // Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes

  Future<NumberTriviaModel> getRandomNumberTrivia();
}
