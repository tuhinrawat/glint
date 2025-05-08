class TravelPost {
  final String username;
  final String userAvatar;
  final String location;
  final String imageUrl;
  final String caption;
  final int likes;
  final int comments;
  final String timeAgo;

  TravelPost({
    required this.username,
    required this.userAvatar,
    required this.location,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });
} 