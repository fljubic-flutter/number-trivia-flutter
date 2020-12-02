import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List _properties;

  Failure([List properties = const []]) : _properties = properties;

  @override
  List<Object> get props => [_properties];
}
