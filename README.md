# Number Trivia

These days I was learning about Test Driven Development principles and best practices for *Clean Architecture*.

## My thoughts about this project

It was nice to learn how to structure code so that it's testable and readable.
In my projects I'm basically never using interfaces/abstract classes though I understand their use better now.
In my opinion they are best used for when we need to test our classes, because they can be mocked which makes testing easy.
They are also useful to make sure we know what we want to do.

In the tutorial, the state management solution is BLoC.
I'm really not a fan of that so I decided to use Riverpod instead.

Since the author knew he'd be using BLoC in advance, he structured his code to be used well with it.
That's why for instance he's using dartz to handle errors. With Riverpod that's completely unnecessary, and errors are handled pretty easily.

Also using Riverpod's providers means we'll be wanting to pass our dependencies with ref.read instead of inside constructors.
So I'd have to change all my tests and classes.
That seemed like too much hustle in this project since I'm not really emotionally connected to it.
Thus there are no tests for the state management part of the code, and also I didn't do widget tests, nor bothered with the design of the app.

It was a nice tutorial nonetheless and I appreciate [ResoCoder](https://www.youtube.com/channel/UCSIvrn68cUk8CS8MbtBmBkA) for making this tutorial. I learned a bunch!
