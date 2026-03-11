import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/gadget_provider.dart';
import '../utils/constants.dart';
import '../widgets/gadget_card.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  String _selectedCategory = AppConstants.categories.first;

  @override
  Widget build(BuildContext context) {
    final gadgetsAsync = ref.watch(
      gadgetsByCategoryProvider(_selectedCategory),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Categories', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Sidebar
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(right: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.05))),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 24),
              itemCount: AppConstants.categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final category = AppConstants.categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCategory = category),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getCategoryIcon(category),
                            size: 20,
                            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            category,
                            style: GoogleFonts.outfit(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Expanded(
                  child: gadgetsAsync.when(
                    data: (gadgets) {
                      if (gadgets.isEmpty) return _buildEmptyState();
                      return GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 280,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: gadgets.length,
                        itemBuilder: (context, index) {
                          return GadgetCard(
                            gadget: gadgets[index],
                            onTap: () => context.push('/details/${gadgets[index].id}'),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('CATEGORIES', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary, letterSpacing: 1.5)),
              const Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey),
              Text(_selectedCategory.toUpperCase(), style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _selectedCategory,
            style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('No gadgets available in this category yet.', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'smartphones': return Icons.smartphone_rounded;
      case 'laptops': return Icons.laptop_mac_rounded;
      case 'smartwatches': return Icons.watch_rounded;
      case 'headphones': return Icons.headphones_rounded;
      case 'tablets': return Icons.tablet_android_rounded;
      case 'cameras': return Icons.camera_alt_rounded;
      default: return Icons.category_rounded;
    }
  }
}
