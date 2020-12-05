import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_number_trivia/core/error/exceptions.dart';
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

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client _client;

  NumberTriviaRemoteDataSourceImpl({@required client}) : _client = client;

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getTriviaFromUrl(url: 'http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl(url: 'http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl({String url}) async {
    http.Response response =
        await _client.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
