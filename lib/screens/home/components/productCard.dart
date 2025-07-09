import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myshop/model/productsList.dart';
import 'package:myshop/screens/home/components/openContainer.dart';
import 'package:myshop/screens/productDetails/productDetails.dart';

class ProductCard extends StatelessWidget {
  final Products product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: OpenContainerWrapper(
              nextScreen: ProductDetails(productId: product.id!,),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: product.image ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding:const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius:const BorderRadius.vertical(bottom: Radius.circular(12)),
              color: Colors.grey[200],
            ),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                  style:const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
                ),
               const SizedBox(height: 4),
                Row(
                  children: [
                   const Icon(Icons.star, color: Colors.amber, size: 16),
                   const SizedBox(width: 4),
                    Text(
                      '${product.rating?.rate ?? 0.0} (${product.rating?.count ?? 0})',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
