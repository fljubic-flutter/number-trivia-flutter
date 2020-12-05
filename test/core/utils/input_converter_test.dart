import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_number_trivia/core/utils/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() => inputConverter = InputConverter());

  group('string is number', () {
    test('should return Right(int) if string is positive number', () {
      final s = "1";

      final result = inputConverter.stringToUnsignedInt(s);

      expect(result, Right(1));
    });

    test('should return Left(InvalidInputFailure) if string is negative number',
        () {
      final s = "-1";

      final result = inputConverter.stringToUnsignedInt(s);

      expect(result, Left(InvalidInputFailure()));
    });
  });

  test('should return Left(InvalidInputFailure) if string is not number', () {
    final s = "asd";

    final result = inputConverter.stringToUnsignedInt(s);

    expect(result, Left(InvalidInputFailure()));
  });
}
