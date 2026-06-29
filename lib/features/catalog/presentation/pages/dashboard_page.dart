import 'dart:ui';
import 'package:fashion_app/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'package:fashion_app/features/auth/presentation/pages/profile_page.dart';
import 'package:fashion_app/features/cart/presentation/pages/cart_page.dart';
import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:fashion_app/features/catalog/presentation/pages/search_page.dart';
import '../../data/models/product_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentNavIndex = 0;
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
      context.read<CartProvider>().fetchCart();
    });
  }

  Future<void> _addToCart(BuildContext context, ProductModel product) async {
    final ok = await context.read<CartProvider>().addToCart(product.id, 1);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? '${product.name.toUpperCase()} added to bag'
              : context.read<CartProvider>().error ?? 'Gagal menambahkan item',
          style: GoogleFonts.manrope(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ok
            ? Theme.of(context).colorScheme.onSurface
            : Colors.redAccent,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final productState = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _currentNavIndex == 0
          ? PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AppBar(
                    backgroundColor: colorScheme.surface.withValues(alpha: 0.75),
                    elevation: 0,
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(Icons.menu, color: colorScheme.onSurface),
                      onPressed: () {},
                    ),
                    title: Text(
                      'FINDYOURFIT',
                      style: GoogleFonts.notoSerif(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.0,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    actions: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.shopping_bag_outlined,
                              color: colorScheme.onSurface,
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
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${cart.totalItems}',
                                    style: TextStyle(
                                      color: colorScheme.surface,
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
            )
          : null,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          // Tab 0: Discover (dashboard content)
          _buildDiscoverBody(colorScheme, productState),

          // Tab 1: Search
          const SearchPage(),

          // Tab 2: Bag (CartPage)
          Padding(
            padding: EdgeInsets.only(
              bottom: 90.0 + MediaQuery.of(context).padding.bottom,
            ),
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) setState(() => _currentNavIndex = 0);
              },
              child: const CartPage(),
            ),
          ),

          // Tab 3: Profile
          Padding(
            padding: EdgeInsets.only(
              bottom: 90.0 + MediaQuery.of(context).padding.bottom,
            ),
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) setState(() => _currentNavIndex = 0);
              },
              child: const ProfilePage(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 90,
            color: colorScheme.surface.withValues(alpha: 0.75),
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  Icons.auto_awesome,
                  'Discover',
                  _currentNavIndex == 0,
                  () => setState(() => _currentNavIndex = 0),
                ),
                _buildNavItem(
                  context,
                  Icons.search,
                  'Search',
                  _currentNavIndex == 1,
                  () => setState(() => _currentNavIndex = 1),
                ),
                _buildNavItem(
                  context,
                  Icons.shopping_bag_outlined,
                  'Bag',
                  _currentNavIndex == 2,
                  () => setState(() => _currentNavIndex = 2),
                ),
                _buildNavItem(
                  context,
                  Icons.person_outline,
                  'Profile',
                  _currentNavIndex == 3,
                  () => setState(() => _currentNavIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoverBody(ColorScheme colorScheme, ProductProvider productState) {
    return RefreshIndicator(
      color: colorScheme.secondary,
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
                      color: colorScheme.surfaceContainer,
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
                        errorBuilder: (_, __, ___) => Container(
                          color: colorScheme.surfaceContainerHigh,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
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
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'NEW COLLECTION',
                            style: GoogleFonts.notoSerif(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                              letterSpacing: -1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            color: colorScheme.surface,
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
                                      color: colorScheme.onSurface,
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
              color: colorScheme.surfaceContainerLow,
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
                                ? colorScheme.secondary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        _categories[index].toUpperCase(),
                        style: GoogleFonts.manrope(
                          color: isSelected
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withValues(alpha: 0.4),
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
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: colorScheme.secondary,
                ),
              ),
            )
          else if (productState.status == ProductStatus.error)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      productState.error ?? 'Gagal memuat koleksi terbaru.',
                      style: GoogleFonts.manrope(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<ProductProvider>().fetchProducts(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface,
                        side: BorderSide(color: colorScheme.outlineVariant),
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
                    color: colorScheme.onSurfaceVariant,
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
                        color: colorScheme.surfaceContainerHigh,
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
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.secondary,
                                    colorScheme.primary,
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
                                        color: colorScheme.surface,
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
                        itemCount: 6, // Menampilkan 6 item biar bisa digeser
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
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isActive
        ? colorScheme.secondary
        : colorScheme.onSurface.withValues(alpha: 0.6);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      ),
    );
  }
}
