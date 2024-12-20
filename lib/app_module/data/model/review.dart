class User {
  final String username;
  final String profileImageUrl;

  User({required this.username, required this.profileImageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      profileImageUrl: json['profile_image_url'] ?? '',
    );
  }
}

class Review {
  final int id;
  final User user;
  final String content;
  final int rating;
  final String dateAdded;
  final String? lastEdited;

  Review({
    required this.id,
    required this.user,
    required this.content,
    required this.rating,
    required this.dateAdded,
    this.lastEdited,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      user: User.fromJson(json['user']),
      content: json['content'] ?? '',
      rating: json['rating'],
      dateAdded: json['date_added'],
      lastEdited: json['last_edited'],
    );
  }
}
