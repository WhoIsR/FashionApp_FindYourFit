import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

enum PaymentCallbackStatus { success, failed, cancelled }

class PaymentCallbackData {
  final PaymentCallbackStatus status;
  final String? reference;
  final String? transactionId;
  final String? error;

  const PaymentCallbackData({
    required this.status,
    this.reference,
    this.transactionId,
    this.error,
  });

  int? get orderId {
    final value = reference;
    if (value == null || !value.startsWith('INV-')) return null;
    return int.tryParse(value.substring(4));
  }
}

class GlobalInstitutePayService {
  final AppLinks _appLinks;
  final StreamController<PaymentCallbackData> _callbackController =
      StreamController<PaymentCallbackData>.broadcast();

  StreamSubscription<Uri>? _linkSubscription;
  PaymentCallbackData? _pendingCallback;
  bool _initialized = false;

  GlobalInstitutePayService({AppLinks? appLinks})
    : _appLinks = appLinks ?? AppLinks();

  static final GlobalInstitutePayService instance = GlobalInstitutePayService();

  static const String merchantId = 'MCH_FINDYOURFIT';
  static const String merchantName = 'FindYourFit';
  static const String callbackUrl = 'findyourfit://payment-callback';

  Stream<PaymentCallbackData> get callbackStream => _callbackController.stream;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        processCallbackUri(initialUri);
      }
    } catch (e) {
      debugPrint('[GlobalInstitutePay] initial link error: $e');
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        try {
          processCallbackUri(uri);
        } catch (e) {
          debugPrint('[GlobalInstitutePay] callback diabaikan: $e');
        }
      },
      onError: (Object error) {
        debugPrint('[GlobalInstitutePay] stream error: $error');
      },
    );
  }

  void processCallbackUri(Uri uri) {
    final callback = parseCallbackUri(uri);
    _pendingCallback = callback;
    _callbackController.add(callback);
  }

  PaymentCallbackData? consumePendingCallback() {
    final callback = _pendingCallback;
    _pendingCallback = null;
    return callback;
  }

  Future<bool> openPaymentApp({required int orderId, required double amount}) {
    return launchUrl(
      buildPaymentUri(orderId: orderId, amount: amount),
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  static Uri buildPaymentUri({required int orderId, required double amount}) {
    return Uri(
      scheme: 'dompetkampus',
      host: 'pay',
      queryParameters: {
        'merchant_id': merchantId,
        'merchant_name': merchantName,
        'amount': amount.toStringAsFixed(0),
        'description': 'Pembayaran order FindYourFit #$orderId',
        'reference': 'INV-$orderId',
        'callback': callbackUrl,
      },
    );
  }

  static PaymentCallbackData parseCallbackUri(Uri uri) {
    if (uri.scheme != 'findyourfit' || uri.host != 'payment-callback') {
      throw const FormatException('Link callback pembayaran tidak valid.');
    }

    final status = switch (uri.queryParameters['status']) {
      'success' => PaymentCallbackStatus.success,
      'failed' => PaymentCallbackStatus.failed,
      'cancelled' => PaymentCallbackStatus.cancelled,
      _ => throw const FormatException('Status pembayaran tidak valid.'),
    };

    return PaymentCallbackData(
      status: status,
      reference: uri.queryParameters['reference'],
      transactionId: uri.queryParameters['transaction_id'],
      error: uri.queryParameters['error'],
    );
  }

  Future<void> dispose() async {
    await _linkSubscription?.cancel();
    await _callbackController.close();
  }
}
