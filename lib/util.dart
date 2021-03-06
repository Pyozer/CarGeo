import 'dart:convert';
import 'dart:math';

import 'package:GeoCar/wheel.dart';

double roundDecimal(double value, int maxDecimal) {
  return double.parse(value.toStringAsFixed(maxDecimal));
}

double calcMissingDist(double wheelSize, double distDiff) {
  //B² = C² - A²
  return sqrt(pow(wheelSize, 2) - pow(distDiff, 2));
}

double calcAngle(double wheelSize, double distDiff, double missingDist) {
  // arcos((b^2 + c^2 - a^2) / 2bc)
  final firstPart = pow(missingDist, 2) + pow(wheelSize, 2) - pow(distDiff, 2);
  return acos(firstPart / (2 * missingDist * wheelSize)) * (180 / pi);
}

String degreeToMinute(double degrees) {
  try {
    final d = degrees.toInt();
    final m = ((degrees - d) * 60).toInt();
    return "$d°$m'";
  } catch (_) {
    return "Error";
  }
}

Wheel jsonToWheel(String jsonValue) {
  return Wheel.fromJson(
      json.decode((jsonValue ?? '{}')) as Map<String, dynamic>);
}
