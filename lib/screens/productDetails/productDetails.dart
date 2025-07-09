
import 'package:flutter/material.dart';
import 'package:myshop/data_provider/data_provider.dart';
import 'package:myshop/model/productsList.dart';
import 'package:myshop/screens/home/components/ErrorWidget.dart';
import 'package:myshop/screens/productDetails/components/details.dart';
import 'package:provider/provider.dart'; 

class ProductDetails extends StatefulWidget {
  final int productId;
  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  
Future<Products?>? _productFuture;   // first initialised with null future

  @override
  void initState() {
    super.initState();
     _loadProduct();
  }
 
 void _loadProduct() {
    setState(() {
      _productFuture = Provider.of<AllDataProvider>(context, listen: false)
          .fetchSingleProduct(productId: widget.productId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Consumer<AllDataProvider>(
      builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          title: const Text(
            'Product Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          
        ),
        body: FutureBuilder<Products?>(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.teal));
            } else if (snapshot.hasError || snapshot.data == null) {
              return ErrorWidgetWithRetry(
                errorMessage: 'Failed to load product details',
                onRetry: _loadProduct
              );
            } else {
              final product = snapshot.data!;
              return Details(product:product);
            }
          },
        ),
        
      );
      }
    );
  }

}
