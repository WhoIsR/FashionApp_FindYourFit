import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // context.select hanya rebuild ketika status berubah (loading→loaded→error).
    // updateItem/removeItem gak ganti status → body gak direbuild.
    final status = context.select<CartProvider, CartStatus>((p) => p.status);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SHOPPING BAG',
          style: GoogleFonts.manrope(
            fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: () => context.read<CartProvider>().clearCart(),
                icon: Icon(Icons.delete_outline, color: colorScheme.onSurface),
              );
            },
          ),
        ],
      ),
      body: switch (status) {
        CartStatus.loading || CartStatus.initial => Center(
          child: CircularProgressIndicator(color: colorScheme.secondary),
        ),
        CartStatus.error => _CartErrorWidget(colorScheme: colorScheme),
        CartStatus.loaded => _CartLoadedContent(colorScheme: colorScheme),
      },
    );
  }
}

/// Once loaded, this widget only rebuilds when item count changes
/// (add/remove item). Quantity changes DO NOT rebuild this widget
/// because they don't touch [items.length].
class _CartLoadedContent extends StatelessWidget {
  final ColorScheme colorScheme;

  const _CartLoadedContent({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final itemCount = context.select<CartProvider, int>((p) => p.items.length);

    if (itemCount == 0) return const _EmptyCart();

    final items = context.read<CartProvider>().items;
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: itemCount,
            separatorBuilder: (_, __) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Divider(color: colorScheme.surfaceContainerHigh),
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return CartItemCard(
                key: ValueKey(item.id),
                itemId: item.id,
                productName: item.product.name,
                productCategory: item.product.category,
                productImageUrl: item.product.imageUrl,
                colorScheme: colorScheme,
              );
            },
          ),
        ),
        Consumer<CartProvider>(
          builder: (context, cart, _) => _CartSubtotal(
            totalPrice: cart.totalPrice,
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }
}

/// Individual cart item card — StatefulWidget + RepaintBoundary.
/// 
/// Only the [Consumer<CartProvider>] wrappers around subtotal & quantity
/// fire on quantity changes. The image, name, category, and layout remain
/// untouched after initial build.
class CartItemCard extends StatefulWidget {
  final int itemId;
  final String productName;
  final String productCategory;
  final String productImageUrl;
  final ColorScheme colorScheme;

  const CartItemCard({
    super.key,
    required this.itemId,
    required this.productName,
    required this.productCategory,
    required this.productImageUrl,
    required this.colorScheme,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  String _formatPrice(double value) => 'Rp ${value.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final cs = widget.colorScheme;

    return RepaintBoundary(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ▸ Image — cached, no fade animation
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: widget.productImageUrl,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholder: (_, __) => Container(
                width: 100, height: 120,
                color: cs.surfaceContainer,
                child: const Center(
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 100, height: 120,
                color: cs.surfaceContainer,
                child: Icon(Icons.broken_image_outlined, color: cs.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // ▸ Name, category, subtotal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName.toUpperCase(),
                  style: GoogleFonts.notoSerif(
                    fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.5,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.productCategory.toUpperCase(),
                  style: GoogleFonts.manrope(
                    fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                // ▸ Subtotal — Consumer, only this text rebuilds
                Consumer<CartProvider>(
                  builder: (context, cart, _) {
                    final freshItem = cart.items.firstWhere(
                      (i) => i.id == widget.itemId,
                      orElse: () => cart.items.first,
                    );
                    return Text(
                      _formatPrice(freshItem.subtotal),
                      style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: cs.secondary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // ▸ Actions (X button + quantity selector)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => context.read<CartProvider>().removeItem(widget.itemId),
                icon: Icon(Icons.close, size: 20, color: cs.onSurfaceVariant),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(border: Border.all(color: cs.outlineVariant)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // read quantity from current state via context.read
                        final qty = context.read<CartProvider>().items
                            .firstWhere((i) => i.id == widget.itemId, orElse: () => context.read<CartProvider>().items.first).quantity;
                        if (qty <= 1) {
                          context.read<CartProvider>().removeItem(widget.itemId);
                        } else {
                          context.read<CartProvider>().updateItem(widget.itemId, qty - 1);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Icon(Icons.remove, size: 16),
                      ),
                    ),
                    // ▸ Quantity — Consumer, only this text rebuilds
                    Consumer<CartProvider>(
                      builder: (context, cart, _) {
                        final freshItem = cart.items.firstWhere(
                          (i) => i.id == widget.itemId,
                          orElse: () => cart.items.first,
                        );
                        return Text(
                          '${freshItem.quantity}',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold, color: cs.onSurface,
                          ),
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        final qty = context.read<CartProvider>().items
                            .firstWhere((i) => i.id == widget.itemId, orElse: () => context.read<CartProvider>().items.first).quantity;
                        context.read<CartProvider>().updateItem(widget.itemId, qty + 1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom subtotal bar
class _CartSubtotal extends StatelessWidget {
  final double totalPrice;
  final ColorScheme colorScheme;
  const _CartSubtotal({required this.totalPrice, required this.colorScheme});

  String _formatPrice(double value) => 'Rp ${value.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.surfaceContainerHigh)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SUBTOTAL', style: GoogleFonts.manrope(
                fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: colorScheme.onSurfaceVariant,
              )),
              Text(_formatPrice(totalPrice), style: GoogleFonts.notoSerif(
                fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface,
              )),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.checkout),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.onSurface,
                foregroundColor: colorScheme.surface,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                elevation: 0,
              ),
              child: Text('CHECKOUT', style: GoogleFonts.manrope(
                fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0,
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: cs.surfaceContainerHigh),
          const SizedBox(height: 24),
          Text('Your bag is empty.', style: GoogleFonts.notoSerif(fontSize: 20, color: cs.onSurfaceVariant)),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.onSurface, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              side: BorderSide(color: cs.outlineVariant),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: Text('CONTINUE SHOPPING', style: GoogleFonts.manrope(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _CartErrorWidget extends StatelessWidget {
  final ColorScheme colorScheme;
  const _CartErrorWidget({required this.colorScheme});
  @override
  Widget build(BuildContext context) {
    final error = context.select<CartProvider, String?>((p) => p.error) ?? 'Gagal memuat cart';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center, style: GoogleFonts.manrope(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.read<CartProvider>().fetchCart(),
              child: const Text('COBA LAGI'),
            ),
          ],
        ),
      ),
    );
  }
}
