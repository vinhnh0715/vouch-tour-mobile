import 'package:flutter/material.dart';
import 'package:vouch_tour_mobile/utils/notification_database.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: NotificationDatabase.instance.getAllNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading notifications'),
            );
          } else {
            final notifications = snapshot.data ?? [];
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final id = notification['id'];

                return Dismissible(
                  key: Key(id.toString()), // Unique key for each notification
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    // Delete the notification when dismissed
                    await NotificationDatabase.instance.deleteNotification(id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notification deleted')),
                    );
                  },
                  child: ListTile(
                    title: Text(notification['title'] ?? ''),
                    subtitle: Text(notification['body'] ?? ''),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
