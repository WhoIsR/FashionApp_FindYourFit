import 'package:fashion_app/core/routes/app_router.dart';
import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:fashion_app/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _paymentMethod = 'bank_transfer';

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String _formatPrice(double value) => 'Rp ${value.toStringAsFixed(0)}';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final orderProv = context.read<OrderProvider>();
    final cartProv = context.read<CartProvider>();
    final ok = await orderProv.checkout(
      shippingAddress: _addressCtrl.text.trim(),
      notes: _notesCtrl.text.trim(),
      paymentMethod: _paymentMethod,
    );

    if (!mounted) return;

    if (!ok || orderProv.lastOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(orderProv.error ?? 'Checkout gagal')),
      );
      return;
    }

    await cartProv.fetchCart();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.paymentPending,
      (route) => route.settings.name == AppRouter.dashboard,
      arguments: orderProv.lastOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final order = context.watch<OrderProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Alamat Pengiriman',
              style: GoogleFonts.notoSerif(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressCtrl,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Alamat lengkap',
                hintText: 'Contoh: Jl. Mawar No. 1',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Alamat wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Catatan',
                hintText: 'Opsional',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Metode Pembayaran',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _PaymentOption(
              value: 'bank_transfer',
              groupValue: _paymentMethod,
              title: 'Virtual Account',
              icon: Icons.credit_card,
              onChanged: (value) => setState(() => _paymentMethod = value),
            ),
            _PaymentOption(
              value: 'gopay',
              groupValue: _paymentMethod,
              title: 'GoPay',
              icon: Icons.account_balance_wallet,
              onChanged: (value) => setState(() => _paymentMethod = value),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.manrope(color: colorScheme.onSurface),
                  ),
                  Text(
                    _formatPrice(cart.totalPrice),
                    style: GoogleFonts.notoSerif(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: order.isCheckingOut ? null : _submit,
                child: order.isCheckingOut
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('BUAT ORDER'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String title;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.secondary.withValues(alpha: 0.08)
              : colorScheme.surface,
          border: Border.all(
            color: selected
                ? colorScheme.secondary
                : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? colorScheme.secondary : null),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.manrope(
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? colorScheme.secondary : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
