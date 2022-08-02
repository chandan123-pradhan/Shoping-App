final String tableNotes = 'notes';

class ItemFields {
  static final List<String> values = [
    /// Add all fields
    id, fetureImage, price, title, description, productId
  ];

  static final String id = '_id';
  static final String fetureImage = 'featureImage';
  static final String price = 'price';
  static final String title = 'title';
  static final String description = 'description';
  static final String productId = 'productId';
}

class Item {
  final int? id;
  final String fetureImage;
  final int price;
  final String title;
  final String description;
  final String productId;

  const Item({
    this.id,
    required this.fetureImage,
    required this.price,
    required this.title,
    required this.description,
    required this.productId,
  });

  Item copy({
    int? id,
    bool? isImportant,
    int? price,
    String? title,
    String? description,
    String? productId,
  }) =>
      Item(
        id: id ?? this.id,
        fetureImage: fetureImage ,
        price: price ?? this.price,
        title: title ?? this.title,
        description: description ?? this.description,
        productId: productId ?? this.productId,
      );

  static Item fromJson(Map<String, Object?> json) => Item(
        id: json[ItemFields.id] as int?,
        fetureImage: json[ItemFields.fetureImage]  as String,
        price: json[ItemFields.price] as int,
        title: json[ItemFields.title] as String,
        description: json[ItemFields.description] as String,
        productId: json[ItemFields.productId] as String,
      );

  Map<String, Object?> toJson() => {
        ItemFields.id: id,
        ItemFields.title: title,
        ItemFields.fetureImage: fetureImage,
        ItemFields.price: price,
        ItemFields.description: description,
        ItemFields.productId: productId
      };
}