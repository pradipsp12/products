import 'package:hive/hive.dart';
import 'package:myshop/model/productsList.dart';
part 'productsHiveAdapter.g.dart';

@HiveType(typeId: 0)
class ProductsHive extends HiveObject {
  @HiveField(0)
  int? id;
  
  @HiveField(1)
  String? title;
  
  @HiveField(2)
  double? price;
  
  @HiveField(3)
  String? description;
  
  @HiveField(4)
  String? category;
  
  @HiveField(5)
  String? image;
  
  @HiveField(6)
  double? rate;
  
  @HiveField(7)
  int? count;
  
  @HiveField(8)
  bool isCached;
  
  @HiveField(9)
  DateTime lastUpdated;

  ProductsHive({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rate,
    this.count,
    this.isCached = false,
    required this.lastUpdated,
  });

  factory ProductsHive.fromProducts(Products product) {
    return ProductsHive(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
      image: product.image,
      rate: product.rating.rate,
      count: product.rating.count,
      isCached: true,
      lastUpdated: DateTime.now(),
    );
  }

  Products toProducts() {
    return Products(
      id: id!,
      title: title!,
      price: price!,
      description: description!,
      category: category!,
      image: image!,
      rating: Rating(rate: rate!, count: count!),
    );
  }
}