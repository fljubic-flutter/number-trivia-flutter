import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_number_trivia/core/error/exceptions.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient client;
  NumberTriviaRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    client = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: client);
  });

  void setUpClient({code}) {
    when(client.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), code),
    );
  }

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;

    test('should use http client to get a number trivia', () async {
      setUpClient(code: 200);

      await remoteDataSource.getConcreteNumberTrivia(testNumber);

      verify(
        client.get('http://numbersapi.com/$testNumber',
            headers: {'Content-Type': 'application/json'}),
      );
    });

    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should return proper data when response status code is 200',
        () async {
      setUpClient(code: 200);

      final result = await remoteDataSource.getConcreteNumberTrivia(testNumber);

      expect(result, testNumberTriviaModel);
    });

    test("should throw ServerException when status code isn't 200", () async {
      setUpClient(code: 404);

      final call = remoteDataSource.getConcreteNumberTrivia;

      expect(() => call(testNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    test('should use http client to get a number trivia', () async {
      setUpClient(code: 200);

      await remoteDataSource.getRandomNumberTrivia();

      verify(
        client.get('http://numbersapi.com/random',
            headers: {'Content-Type': 'application/json'}),
      );
    });

    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should return proper data when response status code is 200',
        () async {
      setUpClient(code: 200);

      final result = await remoteDataSource.getRandomNumberTrivia();

      expect(result, testNumberTriviaModel);
    });

    test("should throw ServerException when status code isn't 200", () async {
      setUpClient(code: 404);

      final call = remoteDataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
