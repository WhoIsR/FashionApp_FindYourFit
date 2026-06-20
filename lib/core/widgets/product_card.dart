import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool isLarge;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.stock = 99,
    this.onTap,
    this.onAddToCart,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isSoldOut = stock == 0;
    final bool isLowStock = stock > 0 && stock <= 5;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Full Bleed + Stock Badge
          AspectRatio(
            aspectRatio: isLarge ? 4 / 5 : 3 / 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Gambar produk
                Container(
                  color: colorScheme.surfaceContainer,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    color: isSoldOut ? Colors.black38 : null,
                    colorBlendMode: isSoldOut ? BlendMode.darken : null,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image_outlined),
                  ),
                ),

                // Badge: SOLD OUT
                if (isSoldOut)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: colorScheme.onSurface.withValues(alpha: 0.85),
                      child: Center(
                        child: Text(
                          'SOLD OUT',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                            color: colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Badge: LOW STOCK
                if (isLowStock)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.9),
                        border: Border.all(
                          color: colorScheme.secondary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        'LOW STOCK',
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: isLarge ? 16 : 12),
          if (isLarge)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toUpperCase(),
                  style: GoogleFonts.notoSerif(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.toUpperCase(),
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${price.toStringAsFixed(0)}',
                      style: GoogleFonts.notoSerif(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: isSoldOut
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.secondary,
                      ),
                    ),
                    if (onAddToCart != null)
                      IconButton(
                        onPressed: isSoldOut ? null : onAddToCart,
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: isSoldOut
                              ? colorScheme.outlineVariant
                              : colorScheme.onSurface,
                        ),
                      ),
                  ],
                ),
              ],
            )
          else ...[
            Text(
              name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerif(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              category.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp ${price.toStringAsFixed(0)}',
                  style: GoogleFonts.notoSerif(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: isSoldOut
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.secondary,
                  ),
                ),
                if (onAddToCart != null)
                  InkWell(
                    onTap: isSoldOut ? null : onAddToCart,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.add_shopping_cart,
                        size: 18,
                        color: isSoldOut
                            ? colorScheme.outlineVariant
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
