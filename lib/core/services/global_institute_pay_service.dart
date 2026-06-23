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
  static const String merchantId = 'MCH_FINDYOURFIT';
  static const String merchantName = 'FindYourFit';
  static const String callbackUrl = 'findyourfit://payment-callback';

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
}
