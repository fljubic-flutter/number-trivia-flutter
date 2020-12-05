import 'dart:convert';

import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_number_trivia/core/error/exceptions.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl localDataSource;
  MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDataSource =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });

  group('getLastNumberTrivia', () {
    // Decode test JSON string to Map<String, dynamic> which is then converted to NumberTriviaModel
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test('should return NumberTriviaModel if there is one in the cache',
        () async {
      when(sharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await localDataSource.getLastNumberTrivia();

      verify(sharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, testNumberTriviaModel);
    });

    test('should throw CacheException if cache is empty', () async {
      when(sharedPreferences.getString(any)).thenReturn(null);

      final call = localDataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);

    // Can't really check if there's data present in preferences,
    // next best thing to do is check that it was called with proper arguments

    test('should call SharedPreferences to cache data', () {
      localDataSource.cacheNumberTrivia(testNumberTriviaModel);

      final expectedJsonString = json.encode(testNumberTriviaModel.toJson());

      verify(sharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
