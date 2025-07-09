import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myshop/data_provider/data_provider.dart';
import 'package:myshop/model/productsHiveAdapter.dart';
import 'package:myshop/screens/home/ProductList.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductsHiveAdapter());

   final productsBox = await Hive.openBox<ProductsHive>('products');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AllDataProvider(productsBox)),
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Myshop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductList(),
    );
  }
}
