import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/controllers/itembag_controller.dart';
import 'package:vouch_tour_mobile/controllers/product_controller.dart';
import 'package:vouch_tour_mobile/models/product_model.dart' as ProductModel;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ProductCardWidget extends ConsumerWidget {
  const ProductCardWidget({
    Key? key,
    required this.productIndex,
  }) : super(key: key);

  final int productIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(proudctNotifierProvider);
    final product = products[productIndex];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      margin: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              color: const Color(0xFFE8F6FB),
              // ...
              child: Image.network(
                  product.images.isNotEmpty ? product.images[0].fileURL : ''),
            ),
          ),
          const Gap(4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.resellPrice} VND',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(proudctNotifierProvider.notifier)
                            .isSelectItem(product.id, !product.isSelected);
                        // Item
                        if (product.isSelected == false) {
                          ref
                              .read(itemBagProvider.notifier)
                              .addNewItemBag(ProductModel.Product(
                                id: product.id,
                                productName: product.productName,
                                resellPrice: product.resellPrice,
                                retailPrice: product.retailPrice,
                                description: product.description,
                                status: product.status,
                                images: product.images,
                                supplier: product.supplier,
                                category: product.category,
                              ));
                        } else {
                          ref
                              .read(itemBagProvider.notifier)
                              .removeItem(product.id);
                        }
                      },
                      icon: const Icon(
                        //Icons.navigate_next_rounded,
                        Icons.check_circle,
                        // product.isSelected
                        //     ? Icons.check_circle
                        //     : Icons.add_circle,
                        color: Colors.green,
                        size: 30,
                      ),
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
