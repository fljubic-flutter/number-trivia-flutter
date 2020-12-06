import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tdd_number_trivia/features/numberTrivia/presentation/riverpod/number_trivia_provider.dart';

class NumberTriviaPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HookBuilder(
              builder: (context) {
                final numberTrivia = useProvider(
                    numberTriviaProvider(textEditingController.value.text));
                return numberTrivia.when(
                  loading: () => CircularProgressIndicator(),
                  data: (value) => Text(value),
                  error: (e, s) => Text("Unexpected error $e"),
                );
              },
            ),
            TextField(
              controller: textEditingController,
              keyboardType: TextInputType.number,
            ),
            RaisedButton(
                child: Text("Search"),
                onPressed: () => context.read(buttonPressedProvider).state =
                    ButtonPressed.concrete),
            RaisedButton(
                child: Text("Get random trivia"),
                onPressed: () => context.read(buttonPressedProvider).state =
                    ButtonPressed.random),
          ],
        ),
      ),
    );
  }
}
