

String calculateOnePercent(double amount) {
  // Convert amountString to double
  // double amount = double.tryParse(amountString) ?? 0.0;

  // Calculate 1% of the amount
  double onePercent = amount * 0.01;

  // Convert onePercent back to string
  String onePercentString = onePercent.toString();

  return onePercentString;
}

double deductOnePercent(double amount) {
  // Calculate 1% of the amount
  double onePercent = amount * 0.01;

  // Deduct 1% from the amount
  double result = amount - onePercent;

  return result;
}



