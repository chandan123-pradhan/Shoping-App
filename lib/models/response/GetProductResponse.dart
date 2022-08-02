class GetProductResponse {
  GetProductResponse({
    required this.status,
    required this.message,
    required this.totalRecord,
    required this.totalPage,
    required this.data,
  });
  late final int status;
  late final String message;
  late final int totalRecord;
  late final int totalPage;
  late final List<Product> data;
  
  GetProductResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    totalRecord = json['totalRecord'];
    totalPage = json['totalPage'];
    data = List.from(json['data']).map((e)=>Product.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['totalRecord'] = totalRecord;
    _data['totalPage'] = totalPage;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Product {
  Product({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.price,
    required this.featuredImage,
    required this.status,
    required this.createdAt,
  });
  late final int id;
  late final String slug;
  late final String title;
  late final String description;
  late final int price;
  late final String featuredImage;
  late final String status;
  late final String createdAt;
  
  Product.fromJson(Map<String, dynamic> json){
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    featuredImage = json['featured_image'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['slug'] = slug;
    _data['title'] = title;
    _data['description'] = description;
    _data['price'] = price;
    _data['featured_image'] = featuredImage;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    return _data;
  }
}