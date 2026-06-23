import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repositories/auth_repository.dart';

class TransactionNotificationData {
  final String title;
  final String body;
  final String? status;
  final String? reference;

  const TransactionNotificationData({
    required this.title,
    required this.body,
    this.status,
    this.reference,
  });

  factory TransactionNotificationData.fromMap(Map<String, dynamic> data) {
    return TransactionNotificationData(
      title: data['title']?.toString() ?? 'Notifikasi transaksi',
      body: data['body']?.toString() ?? '',
      status: data['status']?.toString(),
      reference: data['reference']?.toString(),
    );
  }

  factory TransactionNotificationData.fromMessage(RemoteMessage message) {
    return TransactionNotificationData.fromMap({
      ...message.data,
      if (message.notification?.title != null)
        'title': message.notification!.title,
      if (message.notification?.body != null)
        'body': message.notification!.body,
    });
  }
}

class NotificationService {
  final FirebaseMessaging _messaging;
  final StreamController<TransactionNotificationData> _messageController =
      StreamController<TransactionNotificationData>.broadcast();

  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<String>? _tokenSubscription;
  AuthRepository? _authRepository;
  bool _initialized = false;

  NotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  static final NotificationService instance = NotificationService();

  Stream<TransactionNotificationData> get messages => _messageController.stream;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    _messageSubscription = FirebaseMessaging.onMessage.listen((message) {
      _messageController.add(
        TransactionNotificationData.fromMessage(message),
      );
    });

    _tokenSubscription = _messaging.onTokenRefresh.listen((token) {
      _authRepository?.updateFcmToken(token);
    });
  }

  Future<void> syncToken(AuthRepository repository) async {
    _authRepository = repository;
    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await repository.updateFcmToken(token);
      }
    } catch (e) {
      debugPrint('[NotificationService] Gagal sinkron token FCM: $e');
    }
  }

  Future<void> dispose() async {
    await _messageSubscription?.cancel();
    await _tokenSubscription?.cancel();
    await _messageController.close();
  }
}
