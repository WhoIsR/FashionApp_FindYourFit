import 'package:dompet_kampus_global/core/services/deeplink_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeeplinkPaymentData', () {
    test('membaca data pembayaran dari deeplink merchant', () {
      final uri = Uri.parse(
        'dompetkampus://pay'
        '?merchant_id=MCH_FINDYOURFIT'
        '&merchant_name=FindYourFit'
        '&amount=150000'
        '&description=Pembayaran%20pesanan'
        '&reference=INV-10'
        '&callback=findyourfit%3A%2F%2Fpayment-callback',
      );

      final result = DeeplinkPaymentData.fromUri(uri);

      expect(result.merchantId, 'MCH_FINDYOURFIT');
      expect(result.merchantName, 'FindYourFit');
      expect(result.amount, 150000);
      expect(result.description, 'Pembayaran pesanan');
      expect(result.reference, 'INV-10');
      expect(result.callbackUrl, 'findyourfit://payment-callback');
    });

    test('menolak nominal pembayaran yang tidak positif', () {
      final uri = Uri.parse(
        'dompetkampus://pay'
        '?merchant_id=MCH_FINDYOURFIT'
        '&merchant_name=FindYourFit'
        '&amount=0',
      );

      expect(
        () => DeeplinkPaymentData.fromUri(uri),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
