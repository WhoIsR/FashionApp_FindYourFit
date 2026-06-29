import 'package:fashion_app/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/models/order_model.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchMyOrders();
    });
  }

  String _formatPrice(double value) => 'Rp ${value.toStringAsFixed(0)}';

  String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value.isEmpty ? '-' : value;
    return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
  }

  String _paymentLabel(String method) {
    return switch (method) {
      'global_institute_pay' => 'Kashi E money',
      'bank_transfer' => 'Virtual Account',
      'gopay' => 'GoPay',
      _ => method.isEmpty ? '-' : method,
    };
  }

  int _itemCount(OrderModel order) {
    return order.items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  String _statusLabel(String status) {
    return switch (status) {
      'pending' => 'Menunggu Pembayaran',
      'processing' => 'Sedang Diproses',
      'shipped' => 'Dikirim',
      'delivered' => 'Diterima',
      'cancelled' => 'Dibatalkan',
      _ => status,
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'pending' => Colors.orange,
      'processing' => Colors.blue,
      'shipped' => Colors.purple,
      'delivered' => Colors.green,
      'cancelled' => Colors.red,
      _ => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<OrderProvider>().fetchMyOrders(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (provider.ordersStatus) {
        OrderStatus.loading ||
        OrderStatus.initial => const Center(child: CircularProgressIndicator()),
        OrderStatus.error => _EmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Riwayat belum bisa dimuat',
          subtitle: provider.error ?? 'Gagal mengambil order',
          action: () => context.read<OrderProvider>().fetchMyOrders(),
        ),
        OrderStatus.success =>
          provider.orders.isEmpty
              ? const _EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'Belum ada transaksi',
                  subtitle: 'Transaksi kamu akan muncul di sini setelah checkout.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: provider.orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = provider.orders[index];
                    final statusColor = _statusColor(order.status);
                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border.all(color: colorScheme.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${order.id}',
                                style: GoogleFonts.notoSerif(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                _formatPrice(order.totalAmount),
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _Badge(
                                label: _statusLabel(order.status),
                                color: statusColor,
                              ),
                              _Badge(
                                label: _paymentLabel(order.paymentMethod),
                                color: colorScheme.secondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _InfoRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Tanggal',
                            value: _formatDate(order.createdAt),
                          ),
                          _InfoRow(
                            icon: Icons.shopping_bag_outlined,
                            label: 'Item',
                            value: '${_itemCount(order)} barang',
                          ),
                          if (order.vaNumber != null &&
                              order.vaNumber!.isNotEmpty)
                            _InfoRow(
                              icon: Icons.credit_card_rounded,
                              label: 'Virtual Account',
                              value: order.vaNumber!,
                            ),
                          if (order.shippingAddress.isNotEmpty)
                            _InfoRow(
                              icon: Icons.local_shipping_outlined,
                              label: 'Alamat',
                              value: order.shippingAddress,
                            ),
                          if (order.items.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Divider(color: colorScheme.outlineVariant),
                            const SizedBox(height: 10),
                            Text(
                              order.items.first.productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (order.items.length > 1)
                              Text(
                                '+${order.items.length - 1} produk lainnya',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? action;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerif(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: action,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
