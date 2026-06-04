import 'dart:math';

class UtilsService {
  final Random _random = Random();

  int getRandomInt(int length) => _random.nextInt(length);

  List<int> getMultipleRandomInst(int multipleNumber, int length) {
    final List<int> numbers = List<int>.generate(length, (index) => index);
    numbers.shuffle(_random);
    return numbers.sublist(0, multipleNumber);
  }
}
