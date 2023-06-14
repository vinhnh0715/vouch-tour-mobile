import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/models/category_model.dart' as Model;

import '../../services/api_service.dart';

class CategorySearchPage extends StatefulWidget {
  @override
  _CategorySearchPageState createState() => _CategorySearchPageState();
}

class _CategorySearchPageState extends State<CategorySearchPage> {
  List<dynamic> categories = []; // List to store categories
  String searchText = ''; // Variable to store the search text
  String selectedFilter = 'All'; // Variable to store the selected filter option

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the page is initialized
  }

  // Method to fetch categories from the API
  Future<void> fetchCategories() async {
    try {
      final List<dynamic> fetchedCategories =
          await ApiService.fetchCategories();

      // List<Model.Category> fetchedCategories =
      //     (await ApiService.fetchCategories(jwtToken)).cast<Model.Category>();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Failed to fetch categories: $e');
    }
  }

  // Method to filter categories based on the selected filter option
  List<dynamic> filterCategories() {
    if (selectedFilter == 'All') {
      return categories;
    } else {
      return categories
          .where((category) => category.categoryName.startsWith(selectedFilter))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBar(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: selectedFilter,
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Filter',
              ),
              items: [
                DropdownMenuItem<String>(
                  value: 'All',
                  child: Text('All'),
                ),
                DropdownMenuItem<String>(
                  value: 'A',
                  child: Text('A'),
                ),
                DropdownMenuItem<String>(
                  value: 'B',
                  child: Text('B'),
                ),
                // Add more filter options if needed
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filterCategories().length,
              itemBuilder: (context, index) {
                final category = filterCategories()[index];
                return ListTile(
                  title: Text(category.categoryName),
                  // Add any additional UI elements for each category
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBar({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          // prefixIcon: SvgPicture.asset('assets/icons/search.svg',
          //     fit: BoxFit.scaleDown),
          hintText: 'Find For Nutrisi'),
    );
  }
}
