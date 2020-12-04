import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:tdd_number_trivia/core/network/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(DataConnectionChecker dataConnectionChecker)
      : _dataConnectionChecker = dataConnectionChecker;

  final DataConnectionChecker _dataConnectionChecker;

  @override
  Future<bool> get isConnected {
    return _dataConnectionChecker.hasConnection;
  }
}
