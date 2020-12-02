import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// No tests needed for this class as there is nothing to test

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({
    @required this.text,
    @required this.number,
  });

  // Easy comparison without boilerplate
  @override
  List<Object> get props => [text, number];

  @override
  bool get stringify => true;
}
