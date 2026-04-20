import 'package:fashion_app/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/product_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Begitu halaman dibuka, langsung suruh provider ngambil data baju dari Golang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductProvider>();
    final authState = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withOpacity(0.9),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'DISCOVER',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.onSurface),
            tooltip: 'Keluar',
            onPressed: () async {
              // Kalau logout dipencet, hapus sesi terus tendang ke login
              await authState.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Tampilan tengahnya menyesuaikan status data dari Golang
      body: switch (productState.status) {
        // 1. Kalau lagi nunggu balasan server
        ProductStatus.loading || ProductStatus.initial => const Center(
          child: CircularProgressIndicator(color: AppColors.secondary),
        ),

        // 2. Kalau servernya error atau internet putus
        ProductStatus.error => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                productState.error ?? 'Gagal memuat koleksi terbaru.',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () =>
                    context.read<ProductProvider>().fetchProducts(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurface,
                  side: const BorderSide(color: AppColors.outlineVariant),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'COBA LAGI',
                  style: TextStyle(letterSpacing: 1.5),
                ),
              ),
            ],
          ),
        ),

        // 3. Kalau datanya sukses diambil
        ProductStatus.loaded => RefreshIndicator(
          color: AppColors.secondary,
          onRefresh: () => context.read<ProductProvider>().fetchProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 16,
              mainAxisSpacing: 32,
            ),
            itemCount: productState.products.length,
            itemBuilder: (context, i) {
              final p = productState.products[i];
              return ProductCard(
                name: p.name,
                price: p.price,
                imageUrl: p.imageUrl,
                category: p.category,
              );
            },
          ),
        ),
      },
    );
  }
}
