class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final double rating;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.isAvailable,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        rating: json['rating'],
        isAvailable: json['isAvailable'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'description': description,
        'imageUrl': imageUrl,
        'rating': rating,
        'isAvailable': isAvailable ? 1 : 0,
      };
}
