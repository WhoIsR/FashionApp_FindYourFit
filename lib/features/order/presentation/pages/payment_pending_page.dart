import 'dart:async';

import 'package:fashion_app/core/routes/app_router.dart';
import 'package:fashion_app/core/services/global_institute_pay_service.dart';
import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:fashion_app/features/order/data/models/order_model.dart';
import 'package:fashion_app/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentPendingPage extends StatefulWidget {
  final OrderModel order;

  const PaymentPendingPage({super.key, required this.order});

  @override
  State<PaymentPendingPage> createState() => _PaymentPendingPageState();
}

class _PaymentPendingPageState extends State<PaymentPendingPage> {
  StreamSubscription<PaymentCallbackData>? _callbackSubscription;
  Timer? _statusTimer;
  bool _openingWallet = false;
  String? _walletMessage;

  bool get _isGlobalInstitutePay =>
      widget.order.paymentMethod == GlobalInstitutePayService.paymentMethod;

  @override
  void initState() {
    super.initState();
    if (_isGlobalInstitutePay) {
      _callbackSubscription = GlobalInstitutePayService.instance.callbackStream
          .listen(_handleCallback);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final pending = GlobalInstitutePayService.instance
            .consumePendingCallback();
        if (pending != null) {
          _handleCallback(pending);
        }
        _openWallet();
      });

      _statusTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        _checkStatus();
      });
    }
  }

  @override
  void dispose() {
    _callbackSubscription?.cancel();
    _statusTimer?.cancel();
    super.dispose();
  }

  String _formatPrice(double value) => 'Rp ${value.toStringAsFixed(0)}';

  Future<void> _checkStatus() async {
    await context.read<OrderProvider>().checkPaymentStatus(widget.order.id);
    if (!mounted) return;

    final provider = context.read<OrderProvider>();
    if (provider.payStatus == PaymentCheckStatus.paid) {
      _statusTimer?.cancel();
      await context.read<CartProvider>().fetchCart();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.orderSuccess,
        (route) => route.settings.name == AppRouter.dashboard,
        arguments: provider.lastOrder ?? widget.order,
      );
    }
  }

  Future<void> _openWallet() async {
    if (_openingWallet) return;
    setState(() {
      _openingWallet = true;
      _walletMessage = null;
    });

    try {
      final opened = await GlobalInstitutePayService.instance.openPaymentApp(
        orderId: widget.order.id,
        amount: widget.order.totalAmount,
      );
      if (!mounted) return;
      if (!opened) {
        setState(() {
          _walletMessage = 'Aplikasi Kashi E money tidak dapat dibuka.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _walletMessage =
            'Kashi E money belum terpasang atau tidak dapat dibuka.';
      });
    } finally {
      if (mounted) {
        setState(() => _openingWallet = false);
      }
    }
  }

  Future<void> _handleCallback(PaymentCallbackData callback) async {
    if (!callback.matchesOrder(widget.order.id) || !mounted) return;

    switch (callback.status) {
      case PaymentCallbackStatus.success:
        setState(() {
          _walletMessage = 'Pembayaran diterima. Memeriksa status transaksi...';
        });
        await _checkStatus();
      case PaymentCallbackStatus.failed:
        setState(() {
          _walletMessage =
              'Pembayaran gagal${callback.error == null ? '.' : ': ${callback.error}'}';
        });
      case PaymentCallbackStatus.cancelled:
        setState(() {
          _walletMessage = 'Pembayaran dibatalkan di Kashi E money.';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final order = provider.lastOrder ?? widget.order;
    final isGopay = order.paymentMethod == 'gopay';
    final isGlobalInstitutePay =
        order.paymentMethod == GlobalInstitutePayService.paymentMethod;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Menunggu Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            isGopay || isGlobalInstitutePay
                ? Icons.account_balance_wallet
                : Icons.credit_card,
            size: 72,
            color: isGopay || isGlobalInstitutePay
                ? const Color(0xFF00ADB5)
                : colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            isGlobalInstitutePay
                ? 'Bayar melalui Kashi E money'
                : isGopay
                ? 'Selesaikan Pembayaran via GoPay'
                : 'Selesaikan Pembayaran via Virtual Account',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerif(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Order #${order.id} · ${_formatPrice(order.totalAmount)}',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 28),
          if (isGlobalInstitutePay)
            const _InfoBox(
              title: 'Pembayaran App-to-App',
              value:
                  'Konfirmasi detail transaksi, masukkan PIN, lalu selesaikan verifikasi 2FA di Kashi E money.',
            )
          else if (!isGopay)
            _InfoBox(
              title: 'Nomor Virtual Account',
              value: order.vaNumber ?? '-',
            )
          else
            const _InfoBox(
              title: 'Instruksi GoPay',
              value:
                  'Buka aplikasi GoPay lalu konfirmasi pembayaran order ini.',
            ),
          const SizedBox(height: 24),
          if (isGlobalInstitutePay) ...[
            ElevatedButton.icon(
              onPressed: _openingWallet ? null : _openWallet,
              icon: _openingWallet
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.open_in_new),
              label: Text(
                _openingWallet
                    ? 'Membuka Kashi E money...'
                    : 'Buka Kashi E money',
              ),
            ),
            if (_walletMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _walletMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
          ElevatedButton.icon(
            onPressed: provider.payStatus == PaymentCheckStatus.checking
                ? null
                : _checkStatus,
            icon: provider.payStatus == PaymentCheckStatus.checking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            label: Text(
              provider.payStatus == PaymentCheckStatus.checking
                  ? 'Memeriksa Status...'
                  : 'Cek Status Pembayaran',
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.dashboard,
              (route) => false,
            ),
            child: const Text('Kembali ke Dashboard'),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
