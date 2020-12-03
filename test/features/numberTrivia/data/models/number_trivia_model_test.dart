import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/models/number_trivia_model.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
  test('should be subclass of NumberTrivia entity', () async {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is int',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, testNumberTriviaModel);
      },
    );
    test(
      'should return a valid model when the JSON number is double',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, testNumberTriviaModel);
      },
    );
  });

  group(
    'toJson',
    () => test(
      'should return a JSON containing proper data',
      () async {
        final result = testNumberTriviaModel.toJson();

        final expectedJson = {
          'number': 1,
          'text': 'test text',
        };

        expect(result, expectedJson);
      },
    ),
  );
}
