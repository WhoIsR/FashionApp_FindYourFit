import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool isLarge;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.onTap,
    this.onAddToCart,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Full Bleed (0px Radius)
          AspectRatio(
            aspectRatio: isLarge ? 4 / 5 : 3 / 4,
            child: Container(
              color: AppColors.surfaceContainer,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image_outlined),
              ),
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
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.toUpperCase(),
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                    color: AppColors.onSurfaceVariant,
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
                        color: AppColors.secondary,
                      ),
                    ),
                    if (onAddToCart != null)
                      IconButton(
                        onPressed: onAddToCart,
                        icon: const Icon(Icons.add_shopping_cart, color: AppColors.onSurface),
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
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              category.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
                color: AppColors.onSurfaceVariant,
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
                    color: AppColors.secondary,
                  ),
                ),
                if (onAddToCart != null)
                  InkWell(
                    onTap: onAddToCart,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_shopping_cart, size: 16, color: AppColors.surface),
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
