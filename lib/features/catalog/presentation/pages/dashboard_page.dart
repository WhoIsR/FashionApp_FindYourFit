import 'dart:ui';
import 'package:fashion_app/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/product_provider.dart';
import 'package:fashion_app/features/auth/presentation/pages/profile_page.dart';
import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:fashion_app/features/cart/presentation/pages/cart_page.dart';
import '../../data/models/product_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'All Pieces',
    'Outerwear',
    'Knitwear',
    'Accessories',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  void _addToCart(BuildContext context, ProductModel product) {
    context.read<CartProvider>().addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.name.toUpperCase()} added to bag',
          style: GoogleFonts.manrope(
            color: AppColors.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.onSurface,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: AppColors.surface.withOpacity(0.75),
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: AppColors.onSurface),
                onPressed: () {},
              ),
              title: Text(
                'FINDYOURFIT',
                style: GoogleFonts.notoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                  color: AppColors.onSurface,
                ),
              ),
              actions: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.onSurface,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        );
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          if (cart.totalItems == 0) return const SizedBox();
                          return Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cart.totalItems}',
                              style: const TextStyle(
                                color: AppColors.surface,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.secondary,
        onRefresh: () => context.read<ProductProvider>().fetchProducts(),
        child: CustomScrollView(
          slivers: [
            // 1. Hero Editorial Section
            SliverToBoxAdapter(
              child: SizedBox(
                height: 618,
                width: double.infinity,
                child: ClipRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: AppColors.surfaceContainer,
                      ), // Latar belakang abu-abu agar blur App Bar terlihat pekat di bagian atas
                      Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCuuMf_mQdQQB-EMqobAclE5vTPPNXrL3AR0RT6c_muOWvkdofaO2SkynxUmeIm3q3G-K4U_9Paf5WkvPJwpqN1yVfh_nHSrPTEil4RNcmZ9sg19EVC4spO-z_iIhyWmkOoXCvXQPXCciFBdqcSc3Qp5ggldSPDtlMh_fnd0TsQP9e7z0k44uSGXvN3zFcjFVEW1QYPH8fUcCqwcBa5nb0L7XA8LU48htM8JjeAMfa-6ySfCO7Y-3wMJEPXBVcyjHj1mjtEeNmbl1A3',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppColors.surfaceContainerHigh),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.onSurface.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 32,
                        left: 32,
                        right: 32,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SUMMER 2026',
                              style: GoogleFonts.manrope(
                                color: AppColors.surface,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'NEW COLLECTION',
                              style: GoogleFonts.notoSerif(
                                color: AppColors.surface,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                                letterSpacing: -1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              color: AppColors.surface,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    child: Text(
                                      'EXPLORE NOW',
                                      style: GoogleFonts.manrope(
                                        color: AppColors.onSurface,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Category Filters
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.surfaceContainerLow,
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategoryIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 32),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected
                                  ? AppColors.secondary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          _categories[index].toUpperCase(),
                          style: GoogleFonts.manrope(
                            color: isSelected
                                ? AppColors.onSurface
                                : AppColors.onSurface.withOpacity(0.4),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 3. Product Grid (Asymmetric & Horizontal)
            if (productState.status == ProductStatus.loading ||
                productState.status == ProductStatus.initial)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
              )
            else if (productState.status == ProductStatus.error)
              SliverFillRemaining(
                child: Center(
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
                        style: GoogleFonts.manrope(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton(
                        onPressed: () =>
                            context.read<ProductProvider>().fetchProducts(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.onSurface,
                          side: const BorderSide(
                            color: AppColors.outlineVariant,
                          ),
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
              )
            else if (productState.products.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Koleksi kosong.',
                    style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(top: 48, bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Item 1: Full Width Large Product
                    if (productState.products.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 64,
                        ),
                        child: ProductCard(
                          name: productState.products[0].name,
                          price: productState.products[0].price,
                          imageUrl: productState.products[0].imageUrl,
                          category: productState.products[0].category,
                          stock: productState.products[0].stock,
                          isLarge: true,
                          onAddToCart: () =>
                              _addToCart(context, productState.products[0]),
                        ),
                      ),

                    // Item 2 & 3: Asymmetric Row
                    if (productState.products.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 64,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ProductCard(
                                name: productState.products[1].name,
                                price: productState.products[1].price,
                                imageUrl: productState.products[1].imageUrl,
                                category: productState.products[1].category,
                                stock: productState.products[1].stock,
                                onAddToCart: () => _addToCart(
                                  context,
                                  productState.products[1],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (productState.products.length > 5)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 48,
                                  ), // Asymmetric offset
                                  child: ProductCard(
                                    name: productState.products[5].name,
                                    price: productState.products[5].price,
                                    imageUrl: productState.products[5].imageUrl,
                                    category: productState.products[5].category,
                                    stock: productState.products[5].stock,
                                    onAddToCart: () => _addToCart(
                                      context,
                                      productState.products[5],
                                    ),
                                  ),
                                ),
                              )
                            else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),

                    // Member Exclusive Banner
                    if (productState.products.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 64,
                        ),
                        child: Container(
                          width: double.infinity,
                          color: AppColors.surfaceContainerHigh,
                          padding: const EdgeInsets.symmetric(
                            vertical: 48,
                            horizontal: 32,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'MEMBER EXCLUSIVE',
                                style: GoogleFonts.notoSerif(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Gain early access to our seasonal archives and atelier private sales.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.secondary,
                                      AppColors.secondaryDim,
                                    ],
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 48,
                                        vertical: 16,
                                      ),
                                      child: Text(
                                        'JOIN THE ATELIER',
                                        style: GoogleFonts.manrope(
                                          color: AppColors.surface,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Remaining Products in Horizontal Scroll
                    if (productState.products.isNotEmpty)
                      SizedBox(
                        height: 380, // Approximate height to fit ProductCard
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount:
                              10, // Menampilkan 10 item biar bisa digeser (duplikasi simulasi)
                          itemBuilder: (context, index) {
                            final p = productState
                                .products[index % productState.products.length];
                            return Container(
                              width:
                                  180, // Fixed width so they are neatly aligned side by side
                              margin: const EdgeInsets.only(right: 16),
                              child: ProductCard(
                                name: p.name,
                                price: p.price,
                                imageUrl: p.imageUrl,
                                category: p.category,
                                stock: p.stock,
                                onAddToCart: () => _addToCart(context, p),
                              ),
                            );
                          },
                        ),
                      ),
                  ]),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 90,
            color: AppColors.surface.withOpacity(0.75),
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.auto_awesome, 'Discover', true, () {}),
                _buildNavItem(Icons.search, 'Search', false, () {}),
                _buildNavItem(Icons.shopping_bag_outlined, 'Bag', false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                }),
                _buildNavItem(Icons.person_outline, 'Profile', false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    final color = isActive
        ? AppColors.secondary
        : AppColors.onSurface.withOpacity(0.6);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isActive ? 28 : 24),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.manrope(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
