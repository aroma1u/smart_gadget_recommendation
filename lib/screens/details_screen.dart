import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/gadget_provider.dart';
import '../providers/ai_recommendation_provider.dart';
import '../models/gadget_model.dart';
import '../widgets/tech_button.dart';

class DetailsScreen extends ConsumerWidget {
  final String id;
  const DetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamAsync = ref.watch(gadgetsStreamProvider);
    final aiState = ref.watch(aiRecommendationProvider);

    return streamAsync.when(
      data: (gadgets) {
        GadgetModel? gadget;

        // Try AI Results first
        if (aiState.value != null) {
          final rawMatches = aiState.value!.cast<Map<String, dynamic>>();
          final aiMatchMap = rawMatches.where((r) => (r['id'] ?? r['name']) == id).toList();
          if (aiMatchMap.isNotEmpty) {
            final aiMatch = aiMatchMap.first;
            gadget = GadgetModel(
              id: aiMatch['id'] ?? aiMatch['name'],
              category: 'AI Match',
              name: aiMatch['name'] ?? 'Unknown',
              brand: aiMatch['brand'] ?? 'Unknown',
              price: double.tryParse((aiMatch["price"]?.toString() ?? "0").replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
              imageUrl: aiMatch['imageUrl'] ?? '',
              rating: 4.8,
              shortDesc: aiMatch['explanation'] ?? '',
              specs: (aiMatch['specs'] is Map)
                  ? Map<String, dynamic>.from(aiMatch['specs'] as Map).map((k, v) => MapEntry(k.toString(), v.toString()))
                  : {"Features": aiMatch['keyFeatures'] ?? ''},
            );
          }
        }

        // Fallback to normal database
        if (gadget == null) {
          final targetId = id.toString().trim();
          try {
            gadget = gadgets.firstWhere((g) => g.id.trim() == targetId);
          } catch (_) {
            final trendingAsync = ref.read(trendingGadgetsProvider);
            final trendingGadgets = trendingAsync.value ?? [];
            try {
              gadget = trendingGadgets.firstWhere((g) => g.id.trim() == targetId);
            } catch (_) {
              try {
                gadget = dummyGadgets.firstWhere((g) => g.id.trim() == targetId);
              } catch (_) {}
            }
          }
        }

        if (gadget == null) return _buildNotFound(id);

        final gadgetObj = gadget;
        final favorites = ref.watch(favoritesProvider);
        final isFav = favorites.contains(gadgetObj.id);
        final comparing = ref.watch(compareProvider).any((g) => g.id == gadgetObj.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, gadgetObj, isFav, ref),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, gadgetObj),
                      const SizedBox(height: 32),
                      _buildDescription(gadgetObj),
                      const SizedBox(height: 40),
                      _buildSpecsSection(context, gadgetObj),
                      const SizedBox(height: 40),
                      _buildActionsRow(context, ref, gadgetObj, comparing, isFav),
                      const SizedBox(height: 40),
                      _buildReviewsSection(context, gadgetObj),
                      const SizedBox(height: 40),
                      _buildSimilarSection(context, gadgets, gadgetObj),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, GadgetModel gadget, bool isFav, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
        shadows: const [Shadow(blurRadius: 10, color: Colors.black26)],
      ),
      actions: [
        IconButton(
          onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(gadget.id),
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'gadget-image-${gadget.id}',
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
            child: Center(
              child: gadget.imageUrl.isNotEmpty
                  ? _buildDetailImage(gadget)
                  : _buildDetailPlaceholder(gadget),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GadgetModel gadget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gadget.brand.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                gadget.name,
                style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, height: 1.1),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${gadget.price.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")}',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(gadget.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(GadgetModel gadget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Text(
          gadget.shortDesc,
          style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSpecsSection(BuildContext context, GadgetModel gadget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Technical Specifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: gadget.specs.entries.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e.key.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1)),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Text(
                      e.value.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionsRow(BuildContext context, WidgetRef ref, GadgetModel gadget, bool comparing, bool isFav) {
    return Row(
      children: [
        Expanded(
          child: TechButton(
            onPressed: () {
              if (comparing) {
                ref.read(compareProvider.notifier).removeGadget(gadget.id);
              } else {
                ref.read(compareProvider.notifier).addGadget(gadget);
              }
            },
            text: comparing ? 'Remove' : 'Compare',
            icon: comparing ? Icons.remove_circle_outline : Icons.compare_arrows,
            isPrimary: !comparing,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(gadget.id),
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context, GadgetModel gadget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('User Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),
        if (gadget.reviews.isEmpty)
          const Text('No analyst reviews available yet.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
        else
          ...gadget.reviews.map((review) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(child: Icon(Icons.person, size: 20)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(review, style: const TextStyle(fontSize: 14, height: 1.5)),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildSimilarSection(BuildContext context, List<GadgetModel> gadgets, GadgetModel current) {
    final similar = gadgets.where((g) => g.category == current.category && g.id != current.id).take(4).toList();
    if (similar.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('You Might Also Like', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similar.length,
            itemBuilder: (context, index) {
              final g = similar[index];
              return GestureDetector(
                onTap: () => context.pushReplacement('/details/${g.id}'),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: g.imageUrl.isNotEmpty
                              ? Image.network(g.imageUrl, fit: BoxFit.contain)
                              : const Icon(Icons.devices, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        g.name,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotFound(String id) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Device not found (ID: $id)')),
    );
  }

  Widget _buildDetailImage(GadgetModel gadget) {
    final isAsset = gadget.imageUrl.startsWith('assets/');
    if (isAsset) {
      return Image.asset(
        gadget.imageUrl,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => _buildDetailPlaceholder(gadget),
      );
    } else {
      return Image.network(
        gadget.imageUrl,
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
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildDetailPlaceholder(gadget),
      );
    }
  }

  Widget _buildDetailPlaceholder(GadgetModel gadget) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.devices_rounded, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 12),
        Text(
          gadget.brand,
          style: TextStyle(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
