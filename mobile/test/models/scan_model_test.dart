import 'package:flutter_test/flutter_test.dart';
import 'package:dermascan/core/models/scan_model.dart';

void main() {
  final json = {
    'id': '550e8400-e29b-41d4-a716-446655440000',
    'image_path': 'uploads/abc.jpg',
    'classification': 'Acne',
    'confidence': 0.9234,
    'created_at': '2026-05-26T10:30:00.000Z',
  };

  test('parses from JSON', () {
    final m = ScanModel.fromJson(json);
    expect(m.id, json['id']);
    expect(m.classification, 'Acne');
    expect(m.confidence, 0.9234);
    expect(m.createdAt.year, 2026);
  });

  test('serializes to JSON', () {
    final m = ScanModel.fromJson(json);
    expect(m.toJson()['id'], json['id']);
  });

  test('Equatable compares by value', () {
    expect(ScanModel.fromJson(json), ScanModel.fromJson(json));
  });
}
