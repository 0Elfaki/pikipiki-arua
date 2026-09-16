import 'package:flutter_test/flutter_test.dart';
import 'package:rider_app/core/utils/currency_formatter.dart';
import 'package:rider_app/core/utils/distance_utils.dart';
import 'package:rider_app/core/sync/offline_sync_queue.dart';

void main() {
  group('Pikipiki Arua Rider Utilities & Sync Tests', () {
    test('CurrencyFormatter formats UGX correctly', () {
      expect(CurrencyFormatter.formatUGX(2500), 'UGX 2,500');
      expect(CurrencyFormatter.formatUGX(10000), 'UGX 10,000');
      expect(CurrencyFormatter.formatUGX(0), 'UGX 0');
    });

    test('DistanceUtils calculates distance and boda fare accurately', () {
      // Distance between Arua Main Market (3.0298, 30.9102) and Muni University (3.0112, 30.9189)
      final distance = DistanceUtils.calculateDistanceKm(
        3.0298,
        30.9102,
        3.0112,
        30.9189,
      );
      expect(distance, greaterThan(1.5));
      expect(distance, lessThan(4.0));

      final fare = DistanceUtils.calculateBodaFareUGX(distance);
      expect(fare, greaterThanOrEqualTo(2000));
      // Multiples of 500 UGX
      expect(fare % 500, 0);
    });

    test('OfflineSyncQueue enqueues requests with idempotency keys', () {
      final queue = OfflineSyncQueue();
      final key1 = queue.enqueue('/api/trips', {'rider': 'rider-123'});
      final key2 = queue.enqueue('/api/telemetry', {'lat': 3.03, 'lng': 30.90});

      expect(queue.queue.length, 2);
      expect(queue.queue.first.id, key1);

      queue.remove(key1);
      expect(queue.queue.length, 1);
      expect(queue.queue.first.id, key2);

      queue.clear();
      expect(queue.queue.isEmpty, isTrue);
    });
  });
}
