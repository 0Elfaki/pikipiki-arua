import 'package:flutter_test/flutter_test.dart';
import 'package:driver_app/core/utils/currency_formatter.dart';
import 'package:driver_app/core/utils/distance_utils.dart';
import 'package:driver_app/core/sync/offline_sync_queue.dart';

void main() {
  group('Pikipiki Arua Driver App Tests', () {
    test('CurrencyFormatter formats driver earnings correctly', () {
      expect(CurrencyFormatter.formatUGX(42500), 'UGX 42,500');
      expect(CurrencyFormatter.formatUGX(3000), 'UGX 3,000');
    });

    test('DistanceUtils calculates distance accurately', () {
      final distance = DistanceUtils.calculateDistanceKm(
        3.0315, // Arua Hill Roundabout
        30.9065,
        3.0450, // Onduparaka
        30.8920,
      );
      expect(distance, greaterThan(1.0));
      expect(distance, lessThan(4.0));
    });

    test('DriverOfflineSyncQueue records telemetry coordinates', () {
      final queue = DriverOfflineSyncQueue();
      final id1 = queue.recordLocation(3.0303, 30.9073);
      final id2 = queue.recordLocation(3.0305, 30.9075);

      expect(queue.queue.length, 2);
      expect(queue.queue.first.id, id1);

      queue.remove(id1);
      expect(queue.queue.length, 1);
      expect(queue.queue.first.id, id2);

      queue.clear();
      expect(queue.queue.isEmpty, isTrue);
    });
  });
}
