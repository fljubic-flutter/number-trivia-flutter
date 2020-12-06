import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

import 'features/numberTrivia/presentation/pages/number_trivia_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NumberTriviaPage(),
    );
  }
}
