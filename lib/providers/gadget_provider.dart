import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gadget_model.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

final dummyGadgets = [
  // Flagship Smartphones
  GadgetModel(
    id: 'g1',
    name: 'Samsung Galaxy S24 Ultra',
    brand: 'Samsung',
    category: 'Smartphones',
    price: 129999.0,
    imageUrl: 'assets/images/gadgets/samsung_galaxy_s24.png',
    shortDesc: 'The ultimate AI powerhouse with titanium unibody and S Pen.',
    specs: {
      'Display': '6.8" Dynamic AMOLED 2X, 120Hz',
      'Platform': 'Snapdragon 8 Gen 3',
      'Memory': '12GB RAM, 512GB Storage',
      'Camera': '200MP Quad Camera System',
      'Battery': '5000 mAh, 45W charging',
    },
    rating: 4.9,
    trending: true,
  ),
  GadgetModel(
    id: 'g2',
    name: 'Apple iPhone 15 Pro Max',
    brand: 'Apple',
    category: 'Smartphones',
    price: 159900.0,
    imageUrl: 'assets/images/gadgets/apple_iphone_15.png',
    shortDesc: 'Aerospace-grade titanium design with the A17 Pro chip.',
    specs: {
      'Display': '6.7" Super Retina XDR OLED',
      'Platform': 'A17 Pro (3nm)',
      'Memory': '8GB RAM, 256GB Storage',
      'Camera': '48MP Pro Camera System',
      'Battery': '4441 mAh',
    },
    rating: 4.8,
    trending: true,
  ),
  GadgetModel(
    id: 'g3',
    name: 'Google Pixel 8 Pro',
    brand: 'Google',
    category: 'Smartphones',
    price: 106999.0,
    imageUrl: 'assets/images/gadgets/google_pixel_8.png',
    shortDesc: 'The most advanced Pixel camera yet with Google AI.',
    specs: {
      'Display': '6.7" Super Actua Display',
      'Platform': 'Google Tensor G3',
      'Memory': '12GB RAM, 128GB Storage',
      'Camera': '50MP Triple Camera System',
      'Battery': '5050 mAh',
    },
    rating: 4.7,
    trending: true,
  ),

  // Laptops
  GadgetModel(
    id: 'g4',
    name: 'Apple MacBook Pro 14"',
    brand: 'Apple',
    category: 'Laptops',
    price: 169900.0,
    imageUrl: 'assets/images/gadgets/macbook_pro_14.png',
    shortDesc: 'Supercharged by M3 Pro for pro-level performance.',
    specs: {
      'Display': '14.2" Liquid Retina XDR',
      'Platform': 'Apple M3 Pro chip',
      'Memory': '18GB Unified Memory',
      'Storage': '512GB SSD',
    },
    rating: 4.9,
    trending: true,
  ),
  GadgetModel(
    id: 'g5',
    name: 'ASUS ROG Zephyrus G16',
    brand: 'ASUS',
    category: 'Laptops',
    price: 189990.0,
    imageUrl: 'assets/images/gadgets/asus_rog_zephyrus.png',
    shortDesc: 'Ultra-thin gaming laptop with OLED display.',
    specs: {
      'Display': '16" 2.5K OLED, 240Hz',
      'Platform': 'Intel Core Ultra 9',
      'Memory': '32GB LPDDR5X',
      'Graphics': 'RTX 4070 Laptop GPU',
    },
    rating: 4.8,
    trending: true,
  ),

  // Tablets & Wearables
  GadgetModel(
    id: 'g6',
    name: 'Apple iPad Pro 11"',
    brand: 'Apple',
    category: 'Tablets',
    price: 99900.0,
    imageUrl: 'assets/images/gadgets/apple_ipad_pro.png',
    shortDesc: 'Thinner and more powerful with the M4 chip.',
    specs: {
      'Display': '11" Ultra Retina XDR OLED',
      'Platform': 'Apple M4 chip',
      'Memory': '8GB RAM, 256GB Storage',
    },
    rating: 4.9,
    trending: true,
  ),
  GadgetModel(
    id: 'g7',
    name: 'Apple Watch Series 9',
    brand: 'Apple',
    category: 'Smart Watches',
    price: 41900.0,
    imageUrl: 'assets/images/gadgets/apple_watch_s9.png',
    shortDesc: 'Smarter, brighter, and more powerful.',
    specs: {
      'Platform': 'S9 SiP with Double Tap gesture',
      'Display': 'Always-On Retina display',
      'Features': 'ECG, Blood Oxygen, Heart Rate',
    },
    rating: 4.8,
    trending: true,
  ),
  GadgetModel(
    id: 'g8',
    name: 'Samsung Galaxy Watch6',
    brand: 'Samsung',
    category: 'Smart Watches',
    price: 29999.0,
    imageUrl: 'assets/images/gadgets/samsung_galaxy_watch6.png',
    shortDesc: 'Start your wellness journey with sleek design.',
    specs: {
      'Display': '1.5" Super AMOLED',
      'Platform': 'Exynos W930',
      'Battery': '425 mAh',
    },
    rating: 4.6,
    trending: true,
  ),

  // Audio & Smart Home
  GadgetModel(
    id: 'g9',
    name: 'Sony WH-1000XM5',
    brand: 'Sony',
    category: 'Headphones',
    price: 29990.0,
    imageUrl: 'assets/images/gadgets/sony_wh1000xm5.png',
    shortDesc: 'Industry-leading noise cancellation.',
    specs: {
      'Type': 'Over-ear Headphones',
      'Battery': '30 hours with ANC',
      'Features': 'LDAC, Multipoint connection',
    },
    rating: 4.9,
    trending: true,
  ),
  GadgetModel(
    id: 'g10',
    name: 'Amazon Echo Show 10',
    brand: 'Amazon',
    category: 'Smart Home',
    price: 24999.0,
    imageUrl: 'assets/images/gadgets/amazon_echo_show.png',
    shortDesc: 'HD smart display with motion and Alexa.',
    specs: {
      'Display': '10.1" HD screen that rotates',
      'Camera': '13MP with auto-framing',
      'Comms': 'Built-in Zigbee smart home hub',
    },
    rating: 4.7,
    trending: true,
  )
];

final gadgetsStreamProvider = StreamProvider<List<GadgetModel>>((ref) async* {
  try {
    final firestore = ref.watch(firestoreServiceProvider);
    yield* firestore.getGadgets();
  } catch (e) {
    yield dummyGadgets;
  }
});

final trendingGadgetsProvider = StreamProvider<List<GadgetModel>>((ref) async* {
  try {
    final firestore = ref.watch(firestoreServiceProvider);
    yield* firestore.getTrendingGadgets();
  } catch (e) {
    yield dummyGadgets.where((g) => g.trending).toList();
  }
});

final gadgetsByCategoryProvider =
    StreamProvider.family<List<GadgetModel>, String>((ref, category) async* {
      try {
        final firestore = ref.watch(firestoreServiceProvider);
        yield* firestore.getGadgetsByCategory(category);
      } catch (e) {
        yield dummyGadgets.where((g) => g.category == category).toList();
      }
    });

// Compare State
class CompareNotifier extends Notifier<List<GadgetModel>> {
  @override
  List<GadgetModel> build() => [];

  void addGadget(GadgetModel gadget) {
    if (state.length < 3 && !state.any((g) => g.id == gadget.id)) {
      state = [...state, gadget];
    }
  }

  void removeGadget(String id) {
    state = state.where((g) => g.id != id).toList();
  }

  void clear() {
    state = [];
  }
}

final compareProvider = NotifierProvider<CompareNotifier, List<GadgetModel>>(
  () {
    return CompareNotifier();
  },
);

// Favorites State
class FavoritesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void toggleFavorite(String id) {
    if (state.contains(id)) {
      state = state.where((favId) => favId != id).toList();
    } else {
      state = [...state, id];
    }
  }

  bool isFavorite(String id) {
    return state.contains(id);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<String>>(
  () => FavoritesNotifier(),
);
