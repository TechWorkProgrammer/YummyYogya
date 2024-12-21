import 'dart:convert';

List<Makanan> makananFromJson(String str) =>
    List<Makanan>.from(json.decode(str).map((x) => Makanan.fromJson(x)));

String makananToJson(List<Makanan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Makanan {
  int id;
  String name;
  int price;
  String description;
  String category;
  String restaurant;
  String rating;
  String imageUrl;
  int createdById;

  Makanan({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.restaurant,
    required this.rating,
    required this.imageUrl,
    required this.createdById,
  });

  factory Makanan.fromJson(Map<String, dynamic> json) => Makanan(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    description: json["description"],
    category: json["category"],
    restaurant: json["restaurant"],
    rating: json["rating"],
    imageUrl: json["image_url"],
    createdById: json["created_by_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "description": description,
    "category": category,
    "restaurant": restaurant,
    "rating": rating,
    "image_url": imageUrl,
    "created_by_id": createdById,
  };
}
