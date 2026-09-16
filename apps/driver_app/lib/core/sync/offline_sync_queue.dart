import 'package:uuid/uuid.dart';

class QueuedTelemetry {
  final String id;
  final double latitude;
  final double longitude;
  final DateTime recordedAt;

  QueuedTelemetry({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  });
}

class DriverOfflineSyncQueue {
  final List<QueuedTelemetry> _queue = [];
  final Uuid _uuid = const Uuid();

  List<QueuedTelemetry> get queue => List.unmodifiable(_queue);

  String recordLocation(double lat, double lng) {
    final key = _uuid.v4();
    _queue.add(QueuedTelemetry(
      id: key,
      latitude: lat,
      longitude: lng,
      recordedAt: DateTime.now(),
    ));
    return key;
  }

  void remove(String id) {
    _queue.removeWhere((item) => item.id == id);
  }

  void clear() {
    _queue.clear();
  }
}
