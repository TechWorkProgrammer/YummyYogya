class DetailMakanan {
  final int id;
  final String name;
  final String description;
  final int price;
  final String rating;
  final String restaurant;
  final String imageUrl;
  final List<Review> reviews;

  DetailMakanan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.restaurant,
    required this.imageUrl,
    required this.reviews,
  });

  factory DetailMakanan.fromJson(Map<String, dynamic> json) {
    return DetailMakanan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      rating: json['rating'],
      restaurant: json['restaurant'],
      imageUrl: json['image_url'],
      reviews: (json['reviews'] as List<dynamic>)
          .map((reviewJson) => Review.fromJson(reviewJson))
          .toList(),
    );
  }
}

class Review {
  final String username;
  final int rating;
  final String review;
  final String createdAt;

  Review({
    required this.username,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      username: json['user__username'],
      rating: json['rating'],
      review: json['review'],
      createdAt: json['created_at'],
    );
  }
}
