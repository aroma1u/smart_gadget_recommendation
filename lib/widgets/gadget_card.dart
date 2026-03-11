import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gadget_model.dart';
import '../providers/gadget_provider.dart';

class GadgetCard extends ConsumerStatefulWidget {
  final GadgetModel gadget;
  final VoidCallback onTap;

  const GadgetCard({Key? key, required this.gadget, required this.onTap})
      : super(key: key);

  @override
  ConsumerState<GadgetCard> createState() => _GadgetCardState();
}

class _GadgetCardState extends ConsumerState<GadgetCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final compareList = ref.watch(compareProvider);
    final isComparing = compareList.any((g) => g.id == widget.gadget.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Section
                Expanded(
                  flex: 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                          gradient: LinearGradient(
                            colors: isDark 
                              ? [Colors.white.withOpacity(0.02), Colors.white.withOpacity(0.08)]
                              : [Colors.grey[50]!, Colors.grey[200]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Hero(
                          tag: 'gadget-image-${widget.gadget.id}',
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: widget.gadget.imageUrl.isNotEmpty
                                  ? _buildGadgetImage(context)
                                  : _ImagePlaceholder(
                                      category: widget.gadget.category,
                                      brand: widget.gadget.brand,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      // Rating Badge (Glassmorphism)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _GlassBadge(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                widget.gadget.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Favorite Button
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _GlassBadge(
                          padding: EdgeInsets.zero,
                          child: IconButton(
                            iconSize: 18,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              ref.watch(favoritesProvider).contains(widget.gadget.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ref.watch(favoritesProvider).contains(widget.gadget.id)
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white,
                            ),
                            onPressed: () {
                              ref.read(favoritesProvider.notifier).toggleFavorite(widget.gadget.id);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Info Section
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.gadget.brand.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.gadget.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '₹${widget.gadget.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            _CompareButton(
                              isComparing: isComparing,
                              onPressed: () {
                                if (isComparing) {
                                  ref.read(compareProvider.notifier).removeGadget(widget.gadget.id);
                                } else {
                                  if (compareList.length >= 3) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Max 3 gadgets for comparison')),
                                    );
                                  } else {
                                    ref.read(compareProvider.notifier).addGadget(widget.gadget);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGadgetImage(BuildContext context) {
    final url = widget.gadget.imageUrl;
    final isAsset = url.startsWith('assets/');

    if (isAsset) {
      return Image.asset(
        url,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => _ImagePlaceholder(
          category: widget.gadget.category,
          brand: widget.gadget.brand,
        ),
      );
    } else {
      return Image.network(
        url,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _ImagePlaceholder(
          category: widget.gadget.category,
          brand: widget.gadget.brand,
        ),
      );
    }
  }
}

class _GlassBadge extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _GlassBadge({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CompareButton extends StatelessWidget {
  final bool isComparing;
  final VoidCallback onPressed;

  const _CompareButton({required this.isComparing, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isComparing 
            ? Theme.of(context).colorScheme.primary 
            : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isComparing ? Icons.check_rounded : Icons.compare_arrows_rounded,
          size: 20,
          color: isComparing ? Colors.white : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final String category;
  final String brand;

  const _ImagePlaceholder({required this.category, required this.brand});

  IconData _getCategoryIcon() {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getCategoryIcon(),
            size: 36,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          brand,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).hintColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
