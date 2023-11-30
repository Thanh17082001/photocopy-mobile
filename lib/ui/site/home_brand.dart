import 'package:flutter/material.dart';
import 'package:photocopy/ui/product/accessory_manager.dart';
import 'package:photocopy/ui/product/brand_manager.dart';
import 'package:photocopy/ui/product/product_manager.dart';
import 'package:provider/provider.dart';

class HomeBrand extends StatefulWidget {
  const HomeBrand({super.key});

  @override
  State<HomeBrand> createState() => _HomeBrandState();
}

class _HomeBrandState extends State<HomeBrand> {
  Future getAllBrands(BuildContext context) async {
    await context.read<BrandManager>().fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    final brandManager = BrandManager();
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          margin: const EdgeInsets.only(top:10),
          width: double.infinity,
          child: const Text('Thương hiệu', style:TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700))),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: 120.0,
        width: double.infinity,
        child: FutureBuilder(
            future: getAllBrands(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<BrandManager>(
                    builder: (ctx, brandManager, child) {
                  return GridView.builder(
                      itemCount: brandManager.itemAcount,
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 3),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            final brandId = brandManager.brands[index].id ?? '';
                            await context
                                .read<ProductManager>()
                                .findByIdBrand(brandId);
                                // ignore: use_build_context_synchronously
                                await context
                                .read<AccessoryManager>()
                                .findByIdBrand(brandId);
                          },
                          child: GridTile(
                            // ignore: sort_child_properties_last
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF0E8388), // Màu của viền
                                        width: 2.0, // Độ rộng của viền
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.transparent,
                                      child: Image.network(
                                        'http://10.0.2.2:3000/${brandManager.brands[index].image}',
                                        width: 90.0,
                                        height: 90.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15.0,),
                                Text(
                                  brandManager.brands[index].name
                                          ?.toUpperCase() ??
                                      '',
                                  style: const TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                });
              }
            }),
      )
    ]);
  }
}
