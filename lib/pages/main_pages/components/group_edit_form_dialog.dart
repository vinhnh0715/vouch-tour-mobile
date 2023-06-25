import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vouch_tour_mobile/models/group_model.dart';
import 'package:vouch_tour_mobile/models/menu_model.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';
import 'package:collection/collection.dart';

class GroupEditFormDialog extends StatefulWidget {
  final Group group;
  final Function(Group) onSubmit;

  const GroupEditFormDialog({
    Key? key,
    required this.group,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _GroupEditFormDialogState createState() => _GroupEditFormDialogState();
}

class _GroupEditFormDialogState extends State<GroupEditFormDialog> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  // Declare a variable to hold the selected menu
  List<Menu> menuList = [];
  Menu? selectedMenu;

  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.group.groupName;
    descriptionController.text = widget.group.description;
    quantityController.text = widget.group.quantity.toString();
    startDate = widget.group.startDate;
    endDate = widget.group.endDate;
    fetchMenuList().then((_) {
      selectedMenu =
          menuList.firstWhereOrNull((menu) => menu.id == widget.group.menuId);
    });
  }

  Future<void> fetchMenuList() async {
    try {
      // Fetch the menu list from the API using ApiService
      final menus = await ApiService.fetchMenus();
      setState(() {
        menuList = menus;
      });
    } catch (e) {
      print('Failed to fetch menu list: $e');
    }
  }

  Future<void> updateGroup() async {
    final groupName = groupNameController.text;
    final description = descriptionController.text;
    final quantity = int.tryParse(quantityController.text) ?? 0;

    if (groupName.isEmpty ||
        description.isEmpty ||
        quantity <= 0 ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final updatedGroup = Group(
      id: widget.group.id,
      groupName: groupName,
      description: description,
      quantity: quantity,
      startDate: startDate!,
      endDate: endDate!,
      menuId: selectedMenu?.id ?? '',
    );

    try {
      await ApiService.updateGroup(updatedGroup);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group updated successfully')),
      );
      widget.onSubmit(updatedGroup); // Call the onSubmit callback
      Navigator.of(context).pop(true); // Pop the dialog and return true
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Group'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: groupNameController,
              decoration: const InputDecoration(labelText: 'Group Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {
                        setState(() {
                          startDate = selectedDate;
                        });
                      });
                    },
                    child: Text(
                      startDate != null
                          ? 'Start Date: ${DateFormat('dd/MM/yyyy').format(startDate!)}'
                          : 'Select Start Date',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {
                        setState(() {
                          endDate = selectedDate;
                        });
                      });
                    },
                    child: Text(
                      endDate != null
                          ? 'End Date: ${DateFormat('dd/MM/yyyy').format(endDate!)}'
                          : 'Select End Date',
                    ),
                  ),
                ),
              ],
            ),
            DropdownButton<Menu>(
              value: selectedMenu,
              onChanged: (Menu? newValue) {
                setState(() {
                  selectedMenu = newValue;
                });
              },
              items: menuList.map<DropdownMenuItem<Menu>>((Menu menu) {
                return DropdownMenuItem<Menu>(
                  value: menu,
                  child: Text(menu.title),
                );
              }).toList(),
              hint: const Text('Chọn Menu'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Pop the dialog and return false
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: updateGroup, // Call the updateGroup method
          child: const Text('Update'),
        ),
      ],
    );
  }
}
