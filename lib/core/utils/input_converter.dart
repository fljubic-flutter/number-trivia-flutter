import 'package:dartz/dartz.dart';
import 'package:tdd_number_trivia/core/error/failure.dart';

// Needed because we will be getting a string as input of number

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String s) {
    try {
      final num = int.parse(s);

      if (num < 0) throw FormatException();

      return Right(num);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
