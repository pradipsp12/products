import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myshop/data_provider/data_provider.dart';
import 'package:myshop/screens/home/components/ErrorWidget.dart';
import 'package:myshop/screens/home/components/productCard.dart';
import 'package:myshop/screens/home/components/searchField.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
    Timer? _debounceTimer; 

  @override
  void dispose() {
    _debounceTimer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){
              provider.init();
            },
            icon:const Icon(Icons.refresh, color: Colors.white,),
          )
        ],
        leading:const Icon(Icons.menu, color: Colors.white,),
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SearchField(
            onChange: (value) {
              _debounceTimer?.cancel();
              _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                
                provider.filterProducts(value);
              });
             },
            ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Consumer<AllDataProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return ErrorWidgetWithRetry(
              errorMessage: provider.errorMessage!,
              onRetry: () {
                provider.fetchProducts(showSnack: true);
              },
            );
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          // print(provider.showOfflineBanner);
          return Column(
            children: [
              if (provider.showOfflineBanner)
              Container(
                padding:const EdgeInsets.all(8),
                color: Colors.red,
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Offline mode - showing cached data',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    return ProductCard(product: product);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}




