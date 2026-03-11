import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/gadget_provider.dart';
import 'package:go_router/go_router.dart';

class ComparisonScreen extends ConsumerWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareList = ref.watch(compareProvider);

    if (compareList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Compare', style: GoogleFonts.outfit())),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.compare_arrows_rounded, size: 80, color: Colors.grey.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text('No gadgets selected', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    }

    final List<String> compareLabels = [
      'Brand', 'Price', 'Rating', 'Network', 'Launch', 'Body', 'Display', 'Platform', 'Memory', 
      'Main Camera', 'Selfie Camera', 'Sound', 'Comms', 'Features', 'Battery', 'Misc'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Comparison', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () => ref.read(compareProvider.notifier).clear(),
            icon: const Icon(Icons.clear_all_rounded, size: 20),
            label: const Text('Clear'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabelColumn(context, compareLabels),
                ...compareList.map((gadget) => _buildGadgetColumn(context, ref, gadget, compareLabels)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelColumn(BuildContext context, List<String> labels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 340), // Space for images
        ...labels.map((label) => Container(
          height: 60,
          width: 120,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            label,
            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 0.5),
          ),
        )),
      ],
    );
  }

  Widget _buildGadgetColumn(BuildContext context, WidgetRef ref, dynamic gadget, List<String> labels) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 1),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
      ),
      child: Column(
        children: [
          // Product Info Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: gadget.imageUrl.isNotEmpty
                          ? Image.network(gadget.imageUrl, fit: BoxFit.contain)
                          : const Icon(Icons.devices, size: 80, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () => ref.read(compareProvider.notifier).removeGadget(gadget.id),
                      icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  gadget.name,
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, height: 1.2),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '₹${gadget.price.toStringAsFixed(0)}',
                    style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
          ...labels.map((label) {
            String value = '-';
            if (label == 'Brand') {
              value = gadget.brand;
            } else if (label == 'Price') {
              value = '₹${gadget.price.toStringAsFixed(0)}';
            } else if (label == 'Rating') {
              value = gadget.rating.toString();
            } else {
              value = gadget.specs[label]?.toString() ?? '-';
            }

            return Container(
              height: 60,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.05))),
              ),
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ],
      ),
    );
  }
}
