import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/checkout_success_dialog.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

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
      ),
      body: cartState.items.isEmpty
          ? Center(
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
                      style: GoogleFonts.manrope(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
            )
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
                          // Product Image
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
                          
                          // Product Details
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
                                  'Rp ${item.product.price.toStringAsFixed(0)}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Quantity Controls
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => context.read<CartProvider>().removeFromCart(item.product.id),
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
                                      onTap: () => context.read<CartProvider>().decreaseQuantity(item.product.id),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Icon(Icons.remove, size: 16),
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      onTap: () => context.read<CartProvider>().addToCart(item.product),
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
                      );
                    },
                  ),
                ),
                
                // Bottom Checkout Section
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
                            'Rp ${cartState.totalPrice.toStringAsFixed(0)}',
                            style: GoogleFonts.notoSerif(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: cartState.isCheckingOut
                              ? null
                              : () async {
                                  final success = await context.read<CartProvider>().checkout();
                                  if (success && context.mounted) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => const CheckoutSuccessDialog(),
                                    );
                                  } else if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.read<CartProvider>().checkoutError ?? 'Checkout gagal',
                                          style: GoogleFonts.manrope(
                                            color: colorScheme.surface,
                                          ),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.onSurface,
                            foregroundColor: colorScheme.surface,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            elevation: 0,
                          ),
                          child: cartState.isCheckingOut
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: colorScheme.surface,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
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
    );
  }
}
