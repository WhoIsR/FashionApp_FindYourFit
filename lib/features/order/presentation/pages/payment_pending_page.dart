import 'package:fashion_app/core/routes/app_router.dart';
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
  String _formatPrice(double value) => 'Rp ${value.toStringAsFixed(0)}';

  Future<void> _checkStatus() async {
    await context.read<OrderProvider>().checkPaymentStatus(widget.order.id);
    if (!mounted) return;

    final provider = context.read<OrderProvider>();
    if (provider.payStatus == PaymentCheckStatus.paid) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.orderSuccess,
        (route) => route.settings.name == AppRouter.dashboard,
        arguments: provider.lastOrder ?? widget.order,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final order = provider.lastOrder ?? widget.order;
    final isGopay = order.paymentMethod == 'gopay';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Menunggu Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            isGopay ? Icons.account_balance_wallet : Icons.credit_card,
            size: 72,
            color: isGopay ? const Color(0xFF00ADB5) : colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            isGopay
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
          if (!isGopay)
            _InfoBox(
              title: 'Nomor Virtual Account',
              value: order.vaNumber ?? '-',
            )
          else
            const _InfoBox(
              title: 'Instruksi GoPay',
              value: 'Buka aplikasi GoPay lalu konfirmasi pembayaran order ini.',
            ),
          const SizedBox(height: 24),
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
