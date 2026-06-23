import 'package:fashion_app/core/routes/app_router.dart';
import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  String _formatPrice(double value) => 'Rp ${value.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SHOPPING BAG',
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          if (cartState.items.isNotEmpty)
            IconButton(
              onPressed: () => context.read<CartProvider>().clearCart(),
              icon: Icon(Icons.delete_outline, color: colorScheme.onSurface),
            ),
        ],
      ),
      body: switch (cartState.status) {
        CartStatus.loading || CartStatus.initial => Center(
          child: CircularProgressIndicator(color: colorScheme.secondary),
        ),
        CartStatus.error => _CartError(
          message: cartState.error ?? 'Gagal memuat cart',
          onRetry: () => context.read<CartProvider>().fetchCart(),
        ),
        CartStatus.loaded => cartState.items.isEmpty
            ? const _EmptyCart()
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: cartState.items.length,
                      separatorBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Divider(color: colorScheme.surfaceContainerHigh),
                      ),
                      itemBuilder: (context, index) {
                        final item = cartState.items[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 120,
                              color: colorScheme.surfaceContainer,
                              child: Image.network(
                                item.product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.broken_image_outlined,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name.toUpperCase(),
                                    style: GoogleFonts.notoSerif(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.product.category.toUpperCase(),
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _formatPrice(item.subtotal),
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => context
                                      .read<CartProvider>()
                                      .removeItem(item.id),
                                  icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorScheme.outlineVariant,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: item.quantity <= 1
                                            ? () => context
                                                  .read<CartProvider>()
                                                  .removeItem(item.id)
                                            : () => context
                                                  .read<CartProvider>()
                                                  .updateItem(
                                                    item.id,
                                                    item.quantity - 1,
                                                  ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Icon(Icons.remove, size: 16),
                                        ),
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => context
                                            .read<CartProvider>()
                                            .updateItem(
                                              item.id,
                                              item.quantity + 1,
                                            ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Icon(Icons.add, size: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.surfaceContainerHigh,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SUBTOTAL',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              _formatPrice(cartState.totalPrice),
                              style: GoogleFonts.notoSerif(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, AppRouter.checkout),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.onSurface,
                              foregroundColor: colorScheme.surface,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'CHECKOUT',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      },
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: colorScheme.surfaceContainerHigh,
          ),
          const SizedBox(height: 24),
          Text(
            'Your bag is empty.',
            style: GoogleFonts.notoSerif(
              fontSize: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.onSurface,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              side: BorderSide(color: colorScheme.outlineVariant),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: Text(
              'CONTINUE SHOPPING',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CartError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('COBA LAGI'),
            ),
          ],
        ),
      ),
    );
  }
}
