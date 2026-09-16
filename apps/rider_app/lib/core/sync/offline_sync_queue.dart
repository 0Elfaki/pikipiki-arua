import 'package:uuid/uuid.dart';

class QueuedRequest {
  final String id;
  final String endpoint;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  int retryCount;

  QueuedRequest({
    required this.id,
    required this.endpoint,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'endpoint': endpoint,
        'payload': payload,
        'createdAt': createdAt.toIso8601String(),
        'retryCount': retryCount,
      };

  factory QueuedRequest.fromJson(Map<String, dynamic> json) => QueuedRequest(
        id: json['id'] as String,
        endpoint: json['endpoint'] as String,
        payload: json['payload'] as Map<String, dynamic>,
        createdAt: DateTime.parse(json['createdAt'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
      );
}

class OfflineSyncQueue {
  final List<QueuedRequest> _queue = [];
  final Uuid _uuid = const Uuid();

  List<QueuedRequest> get queue => List.unmodifiable(_queue);

  String enqueue(String endpoint, Map<String, dynamic> payload) {
    final idempotencyKey = _uuid.v4();
    final request = QueuedRequest(
      id: idempotencyKey,
      endpoint: endpoint,
      payload: {...payload, 'idempotency_key': idempotencyKey},
      createdAt: DateTime.now(),
    );
    _queue.add(request);
    return idempotencyKey;
  }

  void remove(String id) {
    _queue.removeWhere((item) => item.id == id);
  }

  void clear() {
    _queue.clear();
  }
}
