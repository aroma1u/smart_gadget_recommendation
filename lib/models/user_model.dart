class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final List<String> favoriteGadgetIds;
  final String role; // 'user' or 'admin'

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    this.favoriteGadgetIds = const [],
    this.role = 'user',
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      favoriteGadgetIds: map['favoriteGadgetIds'] != null
          ? List<String>.from(map['favoriteGadgetIds'])
          : [],
      role: map['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'favoriteGadgetIds': favoriteGadgetIds,
      'role': role,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    List<String>? favoriteGadgetIds,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteGadgetIds: favoriteGadgetIds ?? this.favoriteGadgetIds,
      role: role,
    );
  }
}
