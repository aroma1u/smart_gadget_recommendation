import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/gadget_provider.dart';
import '../models/gadget_model.dart';
import '../widgets/gadget_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesIds = ref.watch(favoritesProvider);
    final streamAsync = ref.watch(gadgetsStreamProvider);
    final trendingAsync = ref.watch(trendingGadgetsProvider);

    List<GadgetModel> favoriteGadgets = [];

    // Helper to find a gadget safely
    GadgetModel? findGadget(String id) {
      final targetId = id.trim();
      GadgetModel? gadget;

      // 1. Check Stream
      if (streamAsync.hasValue) {
        try { gadget = streamAsync.value!.firstWhere((g) => g.id.trim() == targetId); } catch (_) {}
      }
      // 2. Check Trending
      if (gadget == null && trendingAsync.hasValue) {
        try { gadget = trendingAsync.value!.firstWhere((g) => g.id.trim() == targetId); } catch (_) {}
      }
      // 3. Fallback to dummies
      if (gadget == null) {
        try { gadget = dummyGadgets.firstWhere((g) => g.id.trim() == targetId); } catch (_) {}
      }
      return gadget;
    }

    for (final id in favoritesIds) {
      final g = findGadget(id);
      if (g != null) {
        favoriteGadgets.add(g);
      } else {
        // As a fallback for AI recommendations stored in favorites without a full record,
        // we could create a dummy container but for now let's just ignore or show placeholders.
        favoriteGadgets.add(GadgetModel(
            id: id,
            name: "AI Saved Item",
            brand: "AI Match",
            category: "Match",
            price: 0.0,
            imageUrl: "",
            shortDesc: "Details unavailable. Generate again.",
            rating: 4.8,
            trending: false,
            specs: {}));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: favoriteGadgets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any gadget to save it here.',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Browse Gadgets'),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                childAspectRatio: 0.75,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemCount: favoriteGadgets.length,
              itemBuilder: (context, index) {
                final gadget = favoriteGadgets[index];
                return GadgetCard(
                  gadget: gadget,
                  onTap: () => context.push('/details/${gadget.id}'),
                );
              },
            ),
    );
  }
}
