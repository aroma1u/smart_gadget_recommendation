import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/ai_recommendation_provider.dart';
import '../providers/gadget_provider.dart';
import '../models/gadget_model.dart';

class RecommendationResultsScreen extends ConsumerWidget {
  const RecommendationResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiRecommendationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Matches', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Start Over'),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: aiState.when(
        data: (results) {
          if (results.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final rec = results[index];
              return _RecommendationResultCard(rec: rec, index: index);
            },
          );
        },
        loading: () => _buildLoadingState(context),
        error: (error, _) => _buildErrorState(context, error.toString()),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No perfect matches found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Try adjusting your preferences for better results.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back')),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 32),
          Text(
            'Analyzing specs and expert reviews...',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('Finding your perfect match with AI', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text('AI Consultation Failed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () => context.pop(), child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

class _RecommendationResultCard extends ConsumerWidget {
  final Map<String, dynamic> rec;
  final int index;

  const _RecommendationResultCard({required this.rec, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareState = ref.watch(compareProvider);
    final String gId = rec['id'] ?? rec['name'] ?? 'match_$index';
    final isComparing = compareState.any((g) => g.id == gId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () => context.push('/details/$gId'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildRecImage(rec),
                  ),
                  const SizedBox(width: 20),
                  // Basic Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MATCH #${index + 1}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rec['name'] ?? 'Unknown',
                          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            Text(
                              '₹${rec["price"]?.toString().replaceAll("\$", "") ?? "-" }',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Highlights
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (rec['keyFeatures'] ?? '').toString().split(',').take(3).map<Widget>((feature) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
                    ),
                    child: Text(
                      feature.trim(),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // AI Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rec['explanation'] ?? '',
                        style: const TextStyle(fontSize: 13, height: 1.4, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/details/$gId'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text('View Details', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _CompareActionButton(
                    isComparing: isComparing,
                    onPressed: () {
                      final pc = ref.read(compareProvider.notifier);
                      if (isComparing) {
                        pc.removeGadget(gId);
                      } else {
                        final newGadget = GadgetModel(
                          id: gId,
                          category: 'AI Match',
                          name: rec['name'] ?? 'Unknown',
                          brand: rec['brand'] ?? 'Unknown',
                          price: double.tryParse((rec["price"]?.toString() ?? "0").replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
                          imageUrl: rec['imageUrl'] ?? '',
                          rating: 4.8,
                          shortDesc: rec['keyFeatures'] ?? '',
                          specs: (rec['specs'] is Map)
                              ? Map<String, String>.from(rec['specs'] as Map)
                              : {'Features': rec['keyFeatures'] ?? ''},
                        );
                        pc.addGadget(newGadget);
                        if (ref.read(compareProvider).length >= 2) {
                          context.push('/compare');
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
    );
  }

  Widget _buildRecImage(Map<String, dynamic> rec) {
    final url = rec['imageUrl']?.toString() ?? '';
    if (url.isEmpty) {
      return _RecImagePlaceholder(brand: rec['brand']?.toString() ?? '');
    }
    
    final isAsset = url.startsWith('assets/');
    
    if (isAsset) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          url,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _RecImagePlaceholder(brand: rec['brand']?.toString() ?? ''),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              ),
            );
          },
          errorBuilder: (_, _, _) => _RecImagePlaceholder(brand: rec['brand']?.toString() ?? ''),
        ),
      );
    }
  }
}

class _RecImagePlaceholder extends StatelessWidget {
  final String brand;
  const _RecImagePlaceholder({required this.brand});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.devices_rounded, size: 32, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
        const SizedBox(height: 4),
        Text(
          brand,
          style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CompareActionButton extends StatelessWidget {
  final bool isComparing;
  final VoidCallback onPressed;

  const _CompareActionButton({required this.isComparing, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isComparing ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isComparing ? Icons.check_rounded : Icons.compare_arrows_rounded,
              size: 18,
              color: isComparing ? Colors.white : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              isComparing ? 'Comparing' : 'Compare',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isComparing ? Colors.white : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
