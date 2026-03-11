import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/tech_button.dart';
import '../utils/constants.dart';
import '../providers/ai_recommendation_provider.dart';

class RecommendationFormScreen extends ConsumerStatefulWidget {
  final String? initialCategory;

  const RecommendationFormScreen({Key? key, this.initialCategory})
      : super(key: key);

  @override
  ConsumerState<RecommendationFormScreen> createState() =>
      _RecommendationFormScreenState();
}

class _RecommendationFormScreenState
    extends ConsumerState<RecommendationFormScreen> {
  late String _category;
  double _budget = 50000;
  String _brand = '';
  String _usage = AppConstants.usageOptions.first;
  String _ram = '8GB';
  String _storage = '128GB';
  String _cameraQuality = 'Does not matter';
  String _batteryCapacity = 'Does not matter';

  Future<void> _submitForm() async {
    await ref
        .read(aiRecommendationProvider.notifier)
        .getRecommendations(
          gadgetCategory: _category,
          budget: _budget,
          brandPref: _brand,
          usage: _usage,
          ram: _ram,
          storage: _storage,
          cameraQuality: _cameraQuality,
          batteryCapacity: _batteryCapacity,
        );
    if (mounted) {
      context.push('/results');
    }
  }

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory ?? AppConstants.categories.first;
    // Clear previous results on open
    Future.microtask(() => ref.read(aiRecommendationProvider.notifier).clear());
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiRecommendationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Match',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildFormSection(
                  title: 'Core Preferences',
                  icon: Icons.settings_input_component,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdown(
                                'Gadget Type',
                                _category,
                                AppConstants.categories,
                                (v) => setState(() => _category = v!))),
                        const SizedBox(width: 16),
                        Expanded(
                            child: _buildDropdown(
                                'Primary Usage',
                                _usage,
                                AppConstants.usageOptions,
                                (v) => setState(() => _usage = v!))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildBudgetSlider(),
                    const SizedBox(height: 24),
                    _buildTextField('Preferred Brand',
                        'e.g. Apple, Samsung, Sony', (v) => _brand = v),
                  ],
                ),
                const SizedBox(height: 24),
                _buildFormSection(
                  title: 'Technical Specs',
                  icon: Icons.memory,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdown(
                                'Minimum RAM',
                                _ram,
                                ['4GB', '8GB', '16GB', '32GB', '64GB'],
                                (v) => setState(() => _ram = v!))),
                        const SizedBox(width: 16),
                        Expanded(
                            child: _buildDropdown(
                                'Minimum Storage',
                                _storage,
                                ['64GB', '128GB', '256GB', '512GB', '1TB', '2TB'],
                                (v) => setState(() => _storage = v!))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildFormSection(
                  title: 'Experience',
                  icon: Icons.auto_awesome,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdown(
                                'Camera Priority',
                                _cameraQuality,
                                [
                                  'Does not matter',
                                  'Standard',
                                  'Good (Social Media)',
                                  'Excellent (Pro)'
                                ],
                                (v) => setState(() => _cameraQuality = v!))),
                        const SizedBox(width: 16),
                        Expanded(
                            child: _buildDropdown(
                                'Battery Life',
                                _batteryCapacity,
                                [
                                  'Does not matter',
                                  'Average',
                                  'Good (~2 days)',
                                  'Excellent (Multi-day)'
                                ],
                                (v) => setState(() => _batteryCapacity = v!))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TechButton(
                    onPressed: _submitForm,
                    text: 'Generate Recommendations',
                    icon: Icons.auto_awesome,
                    isLoading: aiState.isLoading,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personalize Your Search',
          style: GoogleFonts.outfit(
              fontSize: 32, fontWeight: FontWeight.w900, height: 1.1),
        ),
        const SizedBox(height: 8),
        Text(
          'Our AI uses these preferences to filter through thousands of products to find your top 5 matches.',
          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildFormSection(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items
              .map((e) => DropdownMenuItem(
                  value: e, child: Text(e, overflow: TextOverflow.ellipsis)))
              .toList(),
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        ),
      ],
    );
  }

  Widget _buildBudgetSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Budget Range',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            Text(
                '₹${_budget.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: _budget,
            min: 5000,
            max: 300000,
            divisions: 59,
            onChanged: (val) => setState(() => _budget = val),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
