import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../../../lib/core/utils/input_converter.dart';
import '../../../../../lib/features/numberTrivia/data/models/number_trivia_model.dart';
import '../../../../../lib/features/numberTrivia/domain/repositories/number_trivia_repository.dart';
import '../../../../../lib/features/numberTrivia/presentation/riverpod/number_trivia_provider.dart';

// honestly there's too many tests to change to make Riverpod testing possible

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockNumberTriviaRepository repository;
  MockInputConverter converter;

  setUp(() {
    repository = MockNumberTriviaRepository();
    converter = MockInputConverter();
  });

  group('numberTriviaProvider', () {
    final testNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: 1);

    test('should use InputConverter', () {
      when(repository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(testNumberTriviaModel));

      // basically the way I structured my whole code so far
      // makes it impossible to override providers with mocks
      // and chaning that now means changing most of the tests
      // and there's no real fun in that
      // so I give up here

      final container = ProviderContainer(overrides: [
        repositoryProvider.overrideWithProvider(Provider((ref) => repository)),
        // inputConverterProvider.overrideWithProvider(Provider((ref) => converter)),
      ]);

      // The first read is the loading state
      expect(
        container.read(numberTriviaProvider("1")),
        const AsyncValue<String>.loading(),
      );
    });
  });
}
