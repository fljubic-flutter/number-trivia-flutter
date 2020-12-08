import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_number_trivia/core/error/failure.dart';
import 'package:tdd_number_trivia/core/network/network_info_impl.dart';
import 'package:tdd_number_trivia/core/usecases/usecase.dart';
import 'package:tdd_number_trivia/core/utils/input_converter.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_number_trivia/features/numberTrivia/domain/usecases/get_random_number_trivia.dart';

const INVALID_INPUT_MESSAGE =
    "Invalid input - the number must be a positive integer or zero";

const INITIAL_MESSAGE = "Start search!";

const SERVER_FAILURE_MESSAGE = "Server Failure";

const CACHE_FAILURE_MESSAGE = "Check your internet";

final repositoryProvider = FutureProvider(
  (ref) async => NumberTriviaRepositoryImpl(
    localDataSource: NumberTriviaLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance()),
    remoteDataSource: NumberTriviaRemoteDataSourceImpl(client: http.Client()),
    networkInfo: NetworkInfoImpl(DataConnectionChecker()),
  ),
);

final inputConverterProvider = Provider((ref) => InputConverter());

final numberTriviaProvider = FutureProvider.family((ref, String number) async {
  final repository = ref.read(repositoryProvider).data?.value;
  final converter = ref.read(inputConverterProvider);
  final buttonPressed = ref.watch(buttonPressedProvider).state;

  String message;
  switch (buttonPressed) {
    case ButtonPressed.none:
      message = INITIAL_MESSAGE;
      break;

    case ButtonPressed.concrete:
      final failureOrNumber = converter.stringToUnsignedInt(number);

      if (failureOrNumber.isLeft()) {
        return INVALID_INPUT_MESSAGE;
      } else {
        int num = failureOrNumber.getOrElse(null);
        final failureOrConcreteNumberTrivia =
            await GetConcreteNumberTrivia(repository).call(Params(number: num));

        message = failureOrConcreteNumberTrivia.fold((failure) {
          if (failure is ServerFailure) {
            return SERVER_FAILURE_MESSAGE;
          } else {
            return CACHE_FAILURE_MESSAGE;
          }
        }, (numberTrivia) => numberTrivia.text);
        return message;
      }
      break;
    case ButtonPressed.random:
      final failureOrRandomNumberTrivia =
          await GetRandomNumberTrivia(repository).call(NoParams());
      message = failureOrRandomNumberTrivia.fold((failure) {
        if (failure is ServerFailure) {
          return SERVER_FAILURE_MESSAGE;
        } else {
          return CACHE_FAILURE_MESSAGE;
        }
      }, (numberTrivia) => numberTrivia.text);
  }
  return message;
});

final buttonPressedProvider = StateProvider((ref) => ButtonPressed.none);

enum ButtonPressed {
  none,
  concrete,
  random,
}
