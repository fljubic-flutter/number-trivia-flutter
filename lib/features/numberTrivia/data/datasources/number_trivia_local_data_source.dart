import 'package:tdd_number_trivia/features/numberTrivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache);

  /// Gets the last cached [NumberTriviaModel] which was fetched the last time
  /// the user had connection.
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();
}
