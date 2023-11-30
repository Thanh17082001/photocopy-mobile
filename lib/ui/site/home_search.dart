import 'package:flutter/material.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  Future search(searchValue, BuildContext context) async {
    await context.read<ProductManager>().search(searchValue);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 380.0,
        height: 70.0,
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          controller: _searchController,
          onTapOutside: (event) async {
            // _searchController.clear();
            // ignore: use_build_context_synchronously
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color(0xFF0E8388))),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color(0xFF0E8388))),
              labelText: 'Search...',
              labelStyle: const TextStyle(
                color: Color(
                    0xFF0E8388), // Màu của nhãn khi TextField không được focus
              ),
              floatingLabelStyle: const TextStyle(fontSize: 28.0),
              suffixIcon: IconButton(
                  onPressed: () async {
                    search(_searchText, context);
                  },
                  icon: const Icon(Icons.search))),
          onChanged: (value) async {
            if (value.isNotEmpty) {
              setState(() {
                _searchText = value;
              });
            } else {
              await context.read<ProductManager>().fetchproducts();
            }
          },
        ),
      ),
    );
  }
}
