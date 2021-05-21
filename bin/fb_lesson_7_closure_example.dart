void main() {
  final z = <String, double>{
    'a': 1000,
    'b': 2000,
    'c': 3000,
  };

  final grossSalaryCalculators =
      z.map((key, value) => MapEntry(key, grossSalaryCalculator(value)));

  print(grossSalaryCalculators['a'](80));
  print(grossSalaryCalculators.values.elementAt(0)(80));

  print(grossSalaryCalculators['b'](90));
  print(grossSalaryCalculators.values.elementAt(1)(90));

  print(grossSalaryCalculators['c'](100));
  print(grossSalaryCalculators.values.elementAt(2)(100));
}

double Function(double bonus) grossSalaryCalculator(double basicSalary) {
  final tax = 0.2 * basicSalary;
  return (double bonus) {
    return bonus + tax + basicSalary;
  };
}
