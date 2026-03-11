class GadgetModel {
  final String id;
  final String category;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final double rating;
  final String shortDesc;
  final Map<String, dynamic>
  specs; // { 'RAM': '8GB', 'Processor': 'Snapdragon 8 Gen 2', etc. }
  final List<String> reviews;
  final bool trending;

  GadgetModel({
    required this.id,
    required this.category,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.shortDesc,
    required this.specs,
    this.reviews = const [],
    this.trending = false,
  });

  factory GadgetModel.fromMap(Map<String, dynamic> map, String documentId) {
    return GadgetModel(
      id: documentId,
      category: map['category'] ?? '',
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      shortDesc: map['shortDesc'] ?? '',
      specs: map['specs'] != null
          ? Map<String, dynamic>.from(map['specs'])
          : {},
      reviews: map['reviews'] != null ? List<String>.from(map['reviews']) : [],
      trending: map['trending'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'name': name,
      'brand': brand,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'shortDesc': shortDesc,
      'specs': specs,
      'reviews': reviews,
      'trending': trending,
    };
  }
}
