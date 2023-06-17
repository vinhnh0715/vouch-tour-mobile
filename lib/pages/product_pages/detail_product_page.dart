import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:vouch_tour_mobile/controllers/product_controller.dart';
import 'package:vouch_tour_mobile/pages/product_pages/product_list_page.dart';

class DetailProductPage extends ConsumerWidget {
  DetailProductPage({Key? key, required this.getIndex}) : super(key: key);

  final int getIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final products = ref.watch(proudctNotifierProvider);

    // Check if the products list is empty or if the getIndex is out of range
    if (products.isEmpty || getIndex < 0 || getIndex >= products.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Loading',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: const Center(
          child: Text('Loading...'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: const Color(0xFF022238),
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20),
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.local_mall),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: const Color(0xFFE8F6FB),
              child: Image.network(products[getIndex].images.isNotEmpty
                  ? products[getIndex].images[0].fileURL
                  : ''),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products[getIndex].productName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ).copyWith(color: const Color(0xFF843667)),
                  ),
                  const Gap(12),
                  // RatingBar and review code
                  const Gap(8),
                  Text(products[getIndex].description),
                  const Gap(20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Giá niêm yết: ${products[getIndex].retailPrice} VND',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Container(
                      //   child: Row(
                      //     children: [
                      //       IconButton(
                      //         onPressed: () {
                      //           ref
                      //               .read(proudctNotifierProvider.notifier)
                      //               .decreaseQty(products[getIndex].id);
                      //         },
                      //         icon: const Icon(
                      //           Icons.do_not_disturb_on_outlined,
                      //           size: 30,
                      //         ),
                      //       ),
                      //       Text(
                      //         products[getIndex].qty.toString(),
                      //         style: const TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //         ).copyWith(fontSize: 24),
                      //       ),
                      //       IconButton(
                      //         onPressed: () {
                      //           ref
                      //               .read(proudctNotifierProvider.notifier)
                      //               .incrementQty(products[getIndex].id);
                      //         },
                      //         icon: const Icon(
                      //           Icons.add_circle_outline,
                      //           size: 30,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  Text(
                    'Giá phân phối: ${products[getIndex].resellPrice} VND',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF843667),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {},
                      child: const Text('Add item to bag'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
