// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:dart_time/dart_time.dart';
import 'package:test/test.dart';

void main() {
  group('DartTime', () {
    test('can be instantiated', () {
      expect(DartTime(), isNotNull);
    });
  });
}
