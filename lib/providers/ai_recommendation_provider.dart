import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gadget_model.dart';
import '../services/gemini_service.dart';
import '../providers/auth_provider.dart';
import '../providers/gadget_provider.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

class AiRecommendationNotifier extends Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  @override
  AsyncValue<List<Map<String, dynamic>>> build() => const AsyncValue.data([]);

  Future<void> getRecommendations({
    required String gadgetCategory,
    required double budget,
    required String brandPref,
    required String usage,
    required String ram,
    required String storage,
    required String cameraQuality,
    required String batteryCapacity,
  }) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(geminiServiceProvider);
      
      // Await actual firestore getGadgets Future to ensure we have the live data
      List<GadgetModel> liveGadgets = [];
      try {
        final firestoreService = ref.read(firestoreServiceProvider);
        final liveGadgetsSnapshot = await firestoreService.getGadgets().first;
        liveGadgets = liveGadgetsSnapshot.isNotEmpty ? liveGadgetsSnapshot : dummyGadgets;
      } catch (e) {
        // Fallback gracefully since Firebase might not be configured in the runtime
        liveGadgets = dummyGadgets;
      }

      final results = await service.getRecommendations(
        gadgetCategory: gadgetCategory,
        budget: budget,
        brandPref: brandPref,
        usage: usage,
        ram: ram,
        storage: storage,
        cameraQuality: cameraQuality,
        batteryCapacity: batteryCapacity,
        liveGadgets: liveGadgets,
      );
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

final aiRecommendationProvider =
    NotifierProvider<
      AiRecommendationNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >(() {
      return AiRecommendationNotifier();
    });
