import 'dart:math';

const myData = <double>[2, 1, 3, 6, 9, 10, 11, 13, 18];

void main() {
  declarative();
  imperative();
}

void declarative() {
  var result1 = myData
      .map(addOne)
      .map(square)
      .map(subtractTen)
      .where((x) => x > 5)
      .take(2)
      .toList();
  for (var r1 in result1) {
    print(r1);
  }
}

void imperative() {
  var result2 = doTakeTwo().toList();
  for (var r2 in result2) {
    print(r2);
  }
}

double addOne(double x) {
  print('I am Adding one');
  return x + 1;
}

double square(double x) {
  print('I am doing a square');
  return pow(x, 2);
}

double subtractTen(double x) {
  print('I am subtracting Ten--------------');
  return x - 10;
}

Iterable<double> doAddOne() sync* {
  for (var v in myData) {
    yield addOne(v);
  }
}

Iterable<double> doSquare() sync* {
  for (var v in doAddOne()) {
    yield square(v);
  }
}

Iterable<double> doSubtractTen() sync* {
  for (var v in doSquare()) {
    yield subtractTen(v);
  }
}

Iterable<double> doWhere() sync* {
  bool Function(double) func = (x) => x > 5;

  for (var v in doSubtractTen()) {
    if (func(v)) {
      yield v;
    }
  }
}

Iterable<double> doTakeTwo() sync* {
  var n = 2;
  var i = 0;
  final cursor = doWhere().iterator;
  do {
    if (i != n) {
      cursor.moveNext();
    }
    var v = cursor.current;
    if (i < n) {
      yield v;
      i = i + 1;
    } else {
      break;
    }
  } while (true);
}
