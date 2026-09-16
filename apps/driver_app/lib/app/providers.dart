import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/storage/secure_storage_service.dart';
import '../core/sync/offline_sync_queue.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final driverSyncQueueProvider = Provider<DriverOfflineSyncQueue>((ref) {
  return DriverOfflineSyncQueue();
});
