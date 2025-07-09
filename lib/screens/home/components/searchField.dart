
import 'package:flutter/material.dart';
import 'package:myshop/data_provider/constant/constant.dart';
class SearchField extends StatelessWidget {
  final Function(String) onChange;

  const SearchField({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: Colors.white,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius:  BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            margin:const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration:const BoxDecoration(
             
              borderRadius:  BorderRadius.all(Radius.circular(10)),
            ),
            child:const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
        ),
      ),
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}
