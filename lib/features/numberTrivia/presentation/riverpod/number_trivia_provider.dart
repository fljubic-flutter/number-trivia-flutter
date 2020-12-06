import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_number_trivia/core/network/network_info_impl.dart';
import 'package:tdd_number_trivia/core/utils/input_converter.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_number_trivia/features/numberTrivia/data/repositories/number_trivia_repository_impl.dart';

final repositoryProvider = Provider(
  (ref) => NumberTriviaRepositoryImpl(
    localDataSource:
        NumberTriviaLocalDataSourceImpl(sharedPreferences: SharedPreferences),
    remoteDataSource: NumberTriviaRemoteDataSourceImpl(client: http.Client()),
    networkInfo: NetworkInfoImpl(DataConnectionChecker()),
  ),
);

final inputConverterProvider = Provider((ref) => InputConverter());

final getConcreteNumberTriviaProvider = FutureProvider((ref) {
  // watchat neki statenotifier
  // kada se promjeni readat repository i inputconverter

  // ovisno o dati
});

final numberTriviaProvider = FutureProvider.family((ref, String number) {
  final repository = ref.read(repositoryProvider);
  final converter = ref.read(inputConverterProvider);
  final buttonPressed = ref.watch(buttonPressedProvider).state;

  if (buttonPressed == ButtonPressed.concrete) {
    final num = converter.stringToUnsignedInt(number);

    num.fold((l) => null, (r) => null);
  }

  print(buttonPressed);
});

final buttonPressedProvider = StateProvider((ref) => ButtonPressed.none);

enum ButtonPressed {
  none,
  concrete,
  random,
}

// onPressed promjeni buttonPressedProvider.state
// trebam ga watchat u numberTriviaProvideru
// ako je ButtonPressed.concrete onda prvo convertati broj u int
// readat getConcreteNumberTriviaProvider(repository)
// i await .call()
// ako je ButtonPressed.random readat getRandomNumberTriviaProvider(repository) i opet isto

// u getConcreteNumberTriviaProvideru
