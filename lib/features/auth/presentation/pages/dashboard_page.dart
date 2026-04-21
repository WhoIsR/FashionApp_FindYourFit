import 'dart:ui';
import 'package:fashion_app/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/product_provider.dart';
import 'profile_page.dart';

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
    'Accessories'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
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
              backgroundColor: AppColors.surface.withOpacity(0.8),
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
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined,
                      color: AppColors.onSurface),
                  onPressed: () {},
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCuuMf_mQdQQB-EMqobAclE5vTPPNXrL3AR0RT6c_muOWvkdofaO2SkynxUmeIm3q3G-K4U_9Paf5WkvPJwpqN1yVfh_nHSrPTEil4RNcmZ9sg19EVC4spO-z_iIhyWmkOoXCvXQPXCciFBdqcSc3Qp5ggldSPDtlMh_fnd0TsQP9e7z0k44uSGXvN3zFcjFVEW1QYPH8fUcCqwcBa5nb0L7XA8LU48htM8JjeAMfa-6ySfCO7Y-3wMJEPXBVcyjHj1mjtEeNmbl1A3',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.surfaceContainerHigh),
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
                            'SUMMER 2024',
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
                                      horizontal: 32, vertical: 16),
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

            // 3. Product Grid (Asymmetric)
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
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.onSurfaceVariant),
                      const SizedBox(height: 16),
                      Text(
                        productState.error ?? 'Gagal memuat koleksi terbaru.',
                        style: GoogleFonts.manrope(
                            color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton(
                        onPressed: () =>
                            context.read<ProductProvider>().fetchProducts(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.onSurface,
                          side: const BorderSide(
                              color: AppColors.outlineVariant),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                        child: const Text('COBA LAGI',
                            style: TextStyle(letterSpacing: 1.5)),
                      ),
                    ],
                  ),
                ),
              )
            else if (productState.products.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text('Koleksi kosong.',
                      style: GoogleFonts.manrope(
                          color: AppColors.onSurfaceVariant)),
                ),
              )
            else
              SliverPadding(
                padding:
                    const EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final products = productState.products;

                      // Full Width Item (Index 0)
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 64),
                          child: ProductCard(
                            name: products[0].name,
                            price: products[0].price,
                            imageUrl: products[0].imageUrl,
                            category: products[0].category,
                            isLarge: true,
                          ),
                        );
                      }

                      // Member Exclusive Banner (setelah item 3 kalau ada)
                      if (index == 2 && products.length > 3) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 64),
                          child: Container(
                            width: double.infinity,
                            color: AppColors.surfaceContainerHigh,
                            padding: const EdgeInsets.symmetric(
                                vertical: 48, horizontal: 32),
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
                                        AppColors.secondaryDim
                                      ],
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 48, vertical: 16),
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
                        );
                      }

                      // 2-Column Grid Item pairs
                      // Susun indeks berikutnya menjadi pasangan 2 kolom
                      // Karena kita pakai SliverList untuk custom asymmetric layout
                      // Logic: index 1 -> pair(1,2), index 3 -> pair(3,4), dst.
                      // Tapi karena kita sudah pakai index 2 untuk banner, kita perlu map sisa index.
                      
                      // Untuk memudahkan, kita render baris berisi 2 item.
                      // Index SliverList: 
                      // 0: Item 0
                      // 1: Row (Item 1, Item 2)
                      // 2: Banner
                      // 3: Row (Item 3, Item 4)
                      // 4: Row (Item 5, Item 6)
                      
                      int p1Index = 0;
                      int p2Index = -1;
                      
                      if (index == 1) {
                         p1Index = 1;
                         p2Index = 2;
                      } else if (index > 2) {
                         // index 3 -> 3, 4
                         // index 4 -> 5, 6
                         int baseOffset = 3 + ((index - 3) * 2);
                         p1Index = baseOffset;
                         p2Index = baseOffset + 1;
                      } else {
                         return const SizedBox(); // Fallback untuk index banner (sudah dihandle di atas)
                      }
                      
                      if (p1Index >= products.length) return const SizedBox();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 64),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ProductCard(
                                name: products[p1Index].name,
                                price: products[p1Index].price,
                                imageUrl: products[p1Index].imageUrl,
                                category: products[p1Index].category,
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (p2Index < products.length)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 48), // Offset Asymmetric
                                  child: ProductCard(
                                    name: products[p2Index].name,
                                    price: products[p2Index].price,
                                    imageUrl: products[p2Index].imageUrl,
                                    category: products[p2Index].category,
                                  ),
                                ),
                              )
                            else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      );
                    },
                    // Hitung childCount: 
                    // 1 (full width) + 1 (banner) + ceil((len-1)/2)
                    childCount: productState.products.isEmpty 
                      ? 0 
                      : (productState.products.length <= 1 
                          ? 1 
                          : (productState.products.length <= 3 
                              ? 2 
                              : 3 + ((productState.products.length - 3) / 2).ceil())),
                  ),
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
            color: AppColors.surface.withOpacity(0.85),
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.auto_awesome, 'Discover', true, () {}),
                _buildNavItem(Icons.search, 'Search', false, () {}),
                _buildNavItem(Icons.shopping_bag_outlined, 'Bag', false, () {}),
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

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    final color = isActive ? AppColors.secondary : AppColors.onSurface.withOpacity(0.6);
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
