import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouch_tour_mobile/models/group_model.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';
import 'package:vouch_tour_mobile/pages/main_pages/components/group_form_dialog.dart';
import 'package:vouch_tour_mobile/pages/group_pages/group_page_detail.dart';

import 'components/group_edit_form_dialog.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Group> groups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    try {
      final fetchedGroups = await ApiService.fetchGroups();
      setState(() {
        groups = fetchedGroups;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching groups: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await ApiService.deleteGroup(groupId);
      await fetchGroups(); // Refresh the groups after deletion
    } catch (e) {
      print('Error deleting group: $e');
      // Handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth * 0.1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.white
            ], // Adjust the colors as per your preference
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : groups.isEmpty
                ? const Center(
                    child: Text('You have no groups available'),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingValue),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 16.0, bottom: 10.0),
                            child: Text(
                              'Danh sách các nhóm Tour',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: groups.length,
                              itemBuilder: (context, index) {
                                final group = groups[index];
                                final startDate = DateFormat('dd/MM/yyyy')
                                    .format(group.startDate);
                                final endDate = group.endDate != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(group.endDate)
                                    : 'Not yet';

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GroupPageDetail(group: group),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                group.groupName,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                  'Mô tả nhóm: ${group.description}'),
                                              Text(
                                                  'Số lượng thành viên: ${group.quantity}'),
                                              Text('Ngày bắt đầu: $startDate'),
                                              Text('Ngày kết thúc: $endDate'),
                                              Text('Trạng thái: In Progress'),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      GroupEditFormDialog(
                                                    group: group,
                                                    onSubmit: (updatedGroup) {
                                                      setState(() {
                                                        // Update the groups list with the updated group
                                                        final index = groups
                                                            .indexWhere((g) =>
                                                                g.id ==
                                                                updatedGroup
                                                                    .id);
                                                        if (index != -1) {
                                                          groups[index] =
                                                              updatedGroup;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                // Handle delete button tap
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title:
                                                        const Text('Xác nhận'),
                                                    content: const Text(
                                                        'Bạn có muốn xóa nhóm này?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Hủy'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          // Call the delete API and remove the group
                                                          deleteGroup(
                                                              group.id!);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Xóa',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => GroupFormDialog(
              onSubmit: (newGroup) {
                setState(() {
                  groups.add(newGroup);
                });
              },
            ),
          ).then((value) {
            if (value != null && value) {
              fetchGroups();
            }
          });
        },
      ),
    );
  }
}
