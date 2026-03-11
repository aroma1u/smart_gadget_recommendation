import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/gadget_provider.dart';
import '../utils/constants.dart';
import '../widgets/gadget_card.dart';
import '../widgets/mesh_gradient.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final userProfileStr = ref.watch(currentUserProfileProvider);
    final trendingGadgetsStr = ref.watch(trendingGadgetsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: Text(
                AppConstants.appName,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
              actions: [
                _ThemeToggleButton(themeMode: themeMode, ref: ref),
                userProfileStr.when(
                  data: (user) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        icon: CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          backgroundImage: user?.photoUrl.isNotEmpty == true
                              ? NetworkImage(user!.photoUrl)
                              : null,
                          child: user?.photoUrl.isEmpty == true
                              ? Icon(Icons.person_rounded, size: 20, color: Theme.of(context).colorScheme.primary)
                              : null,
                        ),
                        onPressed: () => context.push('/profile'),
                      ),
                    );
                  },
                  loading: () => const Center(child: SizedBox(width: 40, child: CircularProgressIndicator(strokeWidth: 2))),
                  error: (_, __) => IconButton(icon: const Icon(Icons.error_outline), onPressed: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Animated Mesh Gradient
            Stack(
              children: [
                SizedBox(
                  height: 520,
                  width: double.infinity,
                  child: MeshGradientAnimation(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
                // Subtle glass overlay
                Container(
                  height: 520,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                Positioned(
                  top: -50,
                  right: -50,
                  child: _GlassDecorativeCircle(size: 200, color: Colors.white.withOpacity(0.1)),
                ),
                Positioned(
                  bottom: 20,
                  left: -30,
                  child: _GlassDecorativeCircle(size: 150, color: Colors.white.withOpacity(0.05)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 140, 24, 80),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, color: Colors.amber[300], size: 16),
                              const SizedBox(width: 8),
                              const Text(
                                'AI-Powered Recommendations',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Discover Your Next\nPerfect Gadget',
                          style: GoogleFonts.outfit(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'We analyze thousands of specs to find exactly\nwhat fits your lifestyle and budget.',
                          style: TextStyle(fontSize: 17, color: Colors.white70, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () => context.push('/recommend'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Start Exploring', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Categories
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'Browse Categories', onSeeAll: () {}),
                  const SizedBox(height: 24),
                  _CategoryGrid(),
                ],
              ),
            ),

            // Trending Gadgets
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _SectionHeader(
                title: 'Trending Right Now',
                onSeeAll: () => context.push('/recommend'),
              ),
            ),
            const SizedBox(height: 24),
            trendingGadgetsStr.when(
              data: (gadgets) {
                if (gadgets.isEmpty) return const SizedBox.shrink();
                return SizedBox(
                  height: 380,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    scrollDirection: Axis.horizontal,
                    itemCount: gadgets.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 24),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 280,
                        child: GadgetCard(
                          gadget: gadgets[index],
                          onTap: () => context.push('/details/${gadgets[index].id}'),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: ref.watch(compareProvider).isNotEmpty
          ? _FloatingCompareButton(count: ref.watch(compareProvider).length)
          : null,
    );
  }
}

class _GlassDecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlassDecorativeCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  final ThemeMode themeMode;
  final WidgetRef ref;

  const _ThemeToggleButton({required this.themeMode, required this.ref});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => RotationTransition(turns: anim, child: child),
        child: Icon(
          themeMode == ThemeMode.light ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          key: ValueKey(themeMode),
        ),
      ),
      onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        TextButton.icon(
          onPressed: onSeeAll,
          icon: const Icon(Icons.east_rounded, size: 18),
          label: const Text('View All'),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 6 : 3;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: AppConstants.categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final category = AppConstants.categories[index];
            return _CategoryItem(category: category);
          },
        );
      },
    );
  }
}

class _CategoryItem extends StatefulWidget {
  final String category;
  const _CategoryItem({required this.category});

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => context.push('/recommend', extra: widget.category),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
              : Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Theme.of(context).dividerTheme.color ?? Colors.grey.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _getCategoryIcon(widget.category),
                  size: 36,
                  color: _isHovered 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.category,
                style: GoogleFonts.inter(
                  fontWeight: _isHovered ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                  color: _isHovered ? Theme.of(context).colorScheme.primary : null,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Smartphones': return Icons.smartphone_rounded;
      case 'Laptops': return Icons.laptop_mac_rounded;
      case 'Smart Watches': return Icons.watch_rounded;
      case 'Tablets': return Icons.tablet_mac_rounded;
      case 'Headphones': return Icons.headphones_rounded;
      case 'Smart Home': return Icons.home_rounded;
      default: return Icons.devices_rounded;
    }
  }
}

class _FloatingCompareButton extends StatelessWidget {
  final int count;
  const _FloatingCompareButton({required this.count});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.push('/compare'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.compare_arrows_rounded),
      label: Text(
        'Compare ($count)',
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}
