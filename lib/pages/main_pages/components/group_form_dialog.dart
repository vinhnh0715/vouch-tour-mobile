import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vouch_tour_mobile/models/group_model.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class GroupFormDialog extends StatefulWidget {
  final Function(Group) onSubmit;

  const GroupFormDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _GroupFormDialogState createState() => _GroupFormDialogState();
}

class _GroupFormDialogState extends State<GroupFormDialog> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  Future<void> createGroup() async {
    final groupName = groupNameController.text;
    final description = descriptionController.text;
    final quantity = int.tryParse(quantityController.text) ?? 0;

    if (groupName.isEmpty ||
        description.isEmpty ||
        quantity <= 0 ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền vào tất cả chỗ trống')),
      );
      return;
    }

    final newGroup = Group(
      groupName: groupName,
      description: description,
      quantity: quantity,
      startDate: startDate!,
      endDate: endDate!,
    );

    final response = await ApiService.createGroup(newGroup);
    if (response.statusCode == 201) {
      widget.onSubmit(newGroup); // Call the onSubmit callback
      Navigator.of(context).pop(true); // Pop the dialog and return true
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Tạo nhóm thành công!',
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Tạo nhóm thất bại!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo nhóm Tour mới'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: groupNameController,
              decoration: const InputDecoration(labelText: 'Tên nhóm'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              controller: quantityController,
              decoration:
                  const InputDecoration(labelText: 'Số lượng thành viên'),
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
                        initialDate: DateTime.now(),
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
                          ? 'Ngày bắt đầu: ${DateFormat('dd/MM/yyyy').format(startDate!)}'
                          : 'Hãy chọn ngày bắt đầu',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
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
                          ? 'Ngày kết thúc: ${DateFormat('dd/MM/yyyy').format(endDate!)}'
                          : 'Hãy chọn ngày kết thúc',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Pop the dialog and return false
          },
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: createGroup, // Call the createGroup method
          child: const Text('Tạo'),
        ),
      ],
    );
  }
}
