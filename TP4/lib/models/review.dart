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

  factory Review.fromApi(Map<String, Object?> json) {
    final traveler = json['traveler'] as Map<String, Object?>;
    final createdAt = DateTime.parse(json['createdAt'] as String).toLocal();

    return Review(
      id: json['id'] as String,
      user: traveler['name'] as String,
      avatar: traveler['avatar'] as String,
      rating: json['rating'] as int,
      date: _formatDate(createdAt),
      comment: json['comment'] as String,
      helpful: json['helpfulCount'] as int,
    );
  }

  final String id;
  final String user;
  final String avatar;
  final int rating;
  final String date;
  final String comment;
  final int helpful;
}

class ReviewSummary {
  const ReviewSummary({
    required this.average,
    required this.total,
    required this.distribution,
  });

  factory ReviewSummary.fromApi(Map<String, Object?> json) {
    final distributionJson = json['distribution'] as Map<String, Object?>;

    return ReviewSummary(
      average: (json['average'] as num).toDouble(),
      total: json['total'] as int,
      distribution: {
        for (final star in [1, 2, 3, 4, 5])
          star: distributionJson['$star'] as int? ?? 0,
      },
    );
  }

  static const empty = ReviewSummary(
    average: 0,
    total: 0,
    distribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
  );

  final double average;
  final int total;
  final Map<int, int> distribution;

  int get roundedAverage => average.round().clamp(0, 5);
}

class ReviewBundle {
  const ReviewBundle({required this.summary, required this.reviews});

  factory ReviewBundle.fromApi(Map<String, Object?> json) {
    final data = json['data'] as List<Object?>;

    return ReviewBundle(
      summary: ReviewSummary.fromApi(json['summary'] as Map<String, Object?>),
      reviews: data
          .map((item) => Review.fromApi((item as Map).cast()))
          .toList(),
    );
  }

  final ReviewSummary summary;
  final List<Review> reviews;
}

class ReviewSubmission {
  const ReviewSubmission({required this.summary, required this.review});

  factory ReviewSubmission.fromApi(Map<String, Object?> json) {
    return ReviewSubmission(
      summary: ReviewSummary.fromApi(json['summary'] as Map<String, Object?>),
      review: Review.fromApi(json['data'] as Map<String, Object?>),
    );
  }

  final ReviewSummary summary;
  final Review review;
}

String _formatDate(DateTime value) {
  return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
