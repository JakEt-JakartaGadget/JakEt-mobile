
class User {
  final String username;
  final String profilePicture;

  User({required this.username, required this.profilePicture});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      profilePicture: json['profile_image_url'] ?? '',
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


// import 'package:jaket_mobile/presentation/profile/models/profile_entry.dart';

// class Review {
//   final int id;
//   final UserData user;
//   final String content;
//   final int rating;
//   final String dateAdded;
//   final String? lastEdited;

//   Review({
//     required this.id,
//     required this.user,
//     required this.content,
//     required this.rating,
//     required this.dateAdded,
//     this.lastEdited,
//   });

//   factory Review.fromJson(Map<String, dynamic> json) {
//     return Review(
//       id: json['id'],
//       user: UserData.fromJson(json['user']),
//       content: json['content'] ?? '',
//       rating: json['rating'],
//       dateAdded: json['date_added'],
//       lastEdited: json['last_edited'],
//     );
//   }
// }

