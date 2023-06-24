import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/models/group_model.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';
//import 'package:vouch_tour_mobile/pages/main_pages/components/group_menu_page.dart';
//import 'package:vouch_tour_mobile/pages/main_pages/components/group_orders_page.dart';

class GroupPageDetail extends StatelessWidget {
  final Group group;

  const GroupPageDetail({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Name: ${group.groupName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8.0),
              Text('Description: ${group.description}'),
              Text('Quantity: ${group.quantity}'),
              Text('Start Date: ${group.startDate}'),
              Text('End Date: ${group.endDate}'),
              Text('Status: In Progress'),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.blue, // Set the background color to blue
                      ),
                      onPressed: () {
                        // Handle "Add Cart for Group Menu" button tap
                        // You can implement the desired functionality here
                      },
                      child: Text('Add Cart for Group Menu'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.blue, // Set the background color to blue
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => GroupMenuPage(group: group),
                        //   ),
                        // );
                      },
                      child: Text('View Menu Group'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.blue, // Set the background color to blue
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => GroupOrdersPage(group: group),
                        //   ),
                        // );
                      },
                      child: const Text('View Orders of Group'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
