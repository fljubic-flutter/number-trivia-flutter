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

final repositoryProvider = FutureProvider(
  (ref) async => NumberTriviaRepositoryImpl(
    localDataSource: NumberTriviaLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance()),
    remoteDataSource: NumberTriviaRemoteDataSourceImpl(client: http.Client()),
    networkInfo: NetworkInfoImpl(DataConnectionChecker()),
  ),
);

final inputConverterProvider = Provider((ref) => InputConverter());

// ignore: missing_return
final numberTriviaProvider = FutureProvider.family((ref, String number) async {
  final repository = ref.read(repositoryProvider).data?.value;
  final converter = ref.read(inputConverterProvider);
  final buttonPressed = ref.watch(buttonPressedProvider).state;

  switch (buttonPressed) {
    case ButtonPressed.none:
      return "Start search!";

    case ButtonPressed.concrete:
      final failureOrNumber = converter.stringToUnsignedInt(number);

      if (failureOrNumber.isLeft()) {
        return "Invalid input - the number must be a positive integer or zero";
      } else {
        int num = failureOrNumber.getOrElse(null);
        final failureOrConcreteNumberTrivia =
            await GetConcreteNumberTrivia(repository).call(Params(number: num));

        String message = failureOrConcreteNumberTrivia.fold((failure) {
          if (failure is ServerFailure) {
            return "Server Failure";
          } else {
            return "Cache Failure";
          }
        }, (numberTrivia) => numberTrivia.text);
        return message;
      }
      break;
    case ButtonPressed.random:
      final failureOrRandomNumberTrivia =
          await GetRandomNumberTrivia(repository).call(NoParams());
      String message = failureOrRandomNumberTrivia.fold((failure) {
        if (failure is ServerFailure) {
          return "Server Failure";
        } else {
          return "Check your internet";
        }
      }, (numberTrivia) => numberTrivia.text);
      return message;
  }
});

final buttonPressedProvider = StateProvider((ref) => ButtonPressed.none);

enum ButtonPressed {
  none,
  concrete,
  random,
}
