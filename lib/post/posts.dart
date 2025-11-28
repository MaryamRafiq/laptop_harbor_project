class Post {
  final String image;
  final String name;
  final String specification;
  final double price;
  final String rating; 
  final String configuration;
  final String description;
  final String category;
  final int quantity;

  Post({
    required this.image,
    required this.name,
    required this.specification,
    required this.price,
    required this.rating,
    required this.configuration,
    required this.description,
    required this.category,
    this.quantity = 1, // default 1 is good
  });

  // Factory to create Post from Map (Firebase snapshot)
  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      image: data['image'] ?? '',
      name: data['name'] ?? '',
      specification: data['specification'] ?? '', 
      price: data['price'] ?? '',
      rating: data['rating']?.toString() ?? '0.0', // always string
      configuration: data['configuration'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      quantity: (data['quantity'] != null) 
          ? int.tryParse(data['quantity'].toString()) ?? 1 
          : 1, // ensures quantity is integer
    );
  }

  // Optional: copyWith for updating quantity or other fields
  Post copyWith({
    String? image,
    String? name,
    String? specification,
    double? price,
    String? rating,
    String? configuration,
    String? description,
    String? category,
    int? quantity,
  }) {
    return Post(
      image: image ?? this.image,
      name: name ?? this.name,
      specification: specification ?? this.specification,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      configuration: configuration ?? this.configuration,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }
}
