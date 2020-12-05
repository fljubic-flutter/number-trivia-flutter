import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_number_trivia/core/error/exceptions.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/models/number_trivia_model.dart';
import 'dart:convert';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel);

  /// Gets the last cached [NumberTriviaModel] which was fetched while the user
  /// had connection.
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  NumberTriviaLocalDataSourceImpl({@required sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel) {
    final jsonString = json.encode(triviaModel.toJson());

    return _sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final numberTriviaAsString =
        _sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (numberTriviaAsString == null) throw CacheException();
    // we use Future.value because it makes more sense for the function to return a future
    // in case we switch to say sqlite or any other asynchronous local persistance library

    return Future.value(
        NumberTriviaModel.fromJson(json.decode(numberTriviaAsString)));
  }
}
