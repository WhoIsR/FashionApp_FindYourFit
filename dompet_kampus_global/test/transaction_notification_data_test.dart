import 'package:dompet_kampus_global/core/services/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('membaca data notifikasi transaksi dari payload FCM', () {
    final notification = TransactionNotificationData.fromMap({
      'title': 'Pembayaran berhasil',
      'body': 'Pembayaran FindYourFit telah diproses',
      'status': 'success',
      'reference': 'INV-10',
    });

    expect(notification.title, 'Pembayaran berhasil');
    expect(notification.body, 'Pembayaran FindYourFit telah diproses');
    expect(notification.status, 'success');
    expect(notification.reference, 'INV-10');
  });
}
