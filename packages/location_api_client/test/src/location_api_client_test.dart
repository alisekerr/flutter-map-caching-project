// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:location_api_client/location_api_client.dart';

void main() {
  group('LocationApiClient', () {
    test('can be instantiated', () {
      expect(LocationApiClient(), isNotNull);
    });
  });
}
