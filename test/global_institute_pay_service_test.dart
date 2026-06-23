import 'package:fashion_app/core/services/global_institute_pay_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalInstitutePayService', () {
    test('membentuk deeplink pembayaran untuk Dompet Kampus', () {
      final uri = GlobalInstitutePayService.buildPaymentUri(
        orderId: 10,
        amount: 150000,
      );

      expect(uri.scheme, 'dompetkampus');
      expect(uri.host, 'pay');
      expect(uri.queryParameters['merchant_id'], 'MCH_FINDYOURFIT');
      expect(uri.queryParameters['merchant_name'], 'FindYourFit');
      expect(uri.queryParameters['amount'], '150000');
      expect(uri.queryParameters['reference'], 'INV-10');
      expect(uri.queryParameters['callback'], 'findyourfit://payment-callback');
    });

    test('membaca callback pembayaran sukses dari Dompet Kampus', () {
      final callback = GlobalInstitutePayService.parseCallbackUri(
        Uri.parse(
          'findyourfit://payment-callback'
          '?status=success'
          '&reference=INV-10'
          '&transaction_id=TXN25',
        ),
      );

      expect(callback.status, PaymentCallbackStatus.success);
      expect(callback.reference, 'INV-10');
      expect(callback.transactionId, 'TXN25');
      expect(callback.orderId, 10);
    });

    test('menolak URI yang bukan callback FindYourFit', () {
      expect(
        () => GlobalInstitutePayService.parseCallbackUri(
          Uri.parse('https://example.com/payment-callback?status=success'),
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
