import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/usecases/get_concrete_number_trivia.dart';

// Since our Repository is abstract, we will mock it
// it also allows us to check if a method has been called

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  // Handy Flutter method for tests that runs before every test
  // We initialize our objects in there

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final testNumber = 1;
  final testNumberTrivia = NumberTrivia(text: 'test', number: 1);

  // Ensures that Repository is called and data passes unchanged through Use Case

  test(
    'get trivia for number from repository',
    () async {
      // Should always return right side of Either that contains a test NumberTrivia object
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
    
      final result = await useCase.execute(number: testNumber);

      // Result should return whatever Repository returned
      expect(result, Right(testNumberTrivia));

      // Check that method has been called on Repository
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber));

      // Check that nothing else was called on Repository
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
