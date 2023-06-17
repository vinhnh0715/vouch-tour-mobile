import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/controllers/itembag_controller.dart';
import 'package:vouch_tour_mobile/controllers/product_controller.dart';
//import 'package:flutter_ecommerce/views/detail_page.dart';
import 'package:vouch_tour_mobile/pages/product_pages/components/chip_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

//import '../widgets/ads_banner_widget.dart';
import 'package:vouch_tour_mobile/pages/product_pages/components/card_widget.dart';
import 'package:vouch_tour_mobile/pages/product_pages/detail_product_page.dart';
//import 'cart_page.dart';

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(proudctNotifierProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    final itemBag = ref.watch(itemBagProvider);
    return ProviderScope(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Chip section
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: const [
                      ChipWidget(chipLabel: 'Tất cả'),
                      ChipWidget(chipLabel: 'Đồ ăn'),
                      ChipWidget(chipLabel: 'Bánh kẹo'),
                      ChipWidget(chipLabel: 'Quần áo'),
                      ChipWidget(chipLabel: 'Quà lưu niệm'),
                      ChipWidget(chipLabel: 'Khác'),
                    ],
                  ),
                ),
                // Hot sales section
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Hot Sales',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(4),
                  width: double.infinity,
                  height: 300,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: products.length < 4 ? products.length : 4,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        // Navigate to the detail product page for the tapped product
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProviderScope(
                                child: DetailProductPage(getIndex: index)),
                          ),
                        );
                      },
                      child: ProductCardWidget(productIndex: index),
                    ),
                  ),
                ),

                // Featured products
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Sản phẩm phổ biến',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),

                MasonryGridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  shrinkWrap: true,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProviderScope(
                              child: DetailProductPage(getIndex: index)),
                        )),
                    child: SizedBox(
                      height: 250,
                      child: ProductCardWidget(productIndex: index),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
