class Review {
  const Review({
    required this.id,
    required this.user,
    required this.avatar,
    required this.rating,
    required this.date,
    required this.comment,
    required this.helpful,
  });

  final int id;
  final String user;
  final String avatar;
  final int rating;
  final String date;
  final String comment;
  final int helpful;
}
