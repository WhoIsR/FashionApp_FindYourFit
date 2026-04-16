import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.onTap,
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
            aspectRatio: 3 / 4,
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
          const SizedBox(height: 12),
          Text(
            category.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
