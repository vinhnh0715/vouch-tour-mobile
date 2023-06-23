import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vouch_tour_mobile/models/category_model.dart';
import 'package:vouch_tour_mobile/pages/product_pages/list_product_by_category_id.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';
import 'package:vouch_tour_mobile/pages/main_pages/components/staggered_category_card.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<dynamic> categories = [];
  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch category data from API using ApiService
    List<dynamic> fetchedCategories = await ApiService.fetchCategories();
    setState(() {
      categories = fetchedCategories;
      searchResults = fetchedCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffF9F9F9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Align(
              alignment: Alignment(-1, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Danh sách phân loại sản phẩm',
                  style: TextStyle(
                    color: Color(0xff202020),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tìm loại sản phẩm',
                  prefixIcon: SvgPicture.asset(
                    'lib/assets/icons/search_icon.svg',
                    fit: BoxFit.scaleDown,
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    List<dynamic> tempList = categories
                        .where((category) => category.categoryName
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    setState(() {
                      searchResults = tempList;
                    });
                  } else {
                    setState(() {
                      searchResults = categories;
                    });
                  }
                },
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: StaggeredCardCard(
                    begin: searchResults[index].begin,
                    end: searchResults[index].end,
                    categoryId: searchResults[index].id,
                    categoryName: searchResults[index].categoryName,
                    assetPath: searchResults[index].image,
                    onTap: (categoryId) async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ListProductByCategoryId(
                            categoryId: categoryId,
                          ),
                        ),
                      );

                      // Handle the result from the ListProductByCategoryId if needed
                      if (result == true) {
                        // Fetch the API categories again
                        fetchData();
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
