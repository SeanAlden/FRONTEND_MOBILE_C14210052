// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ta_c14210052/constant/api_url.dart';

// class NotificationPage extends StatefulWidget {
//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   List notifications = [];

//   Future<void> fetchNotifications() async {
//     final response = await http.get(Uri.parse(
//         '$responseUrl/api/notifications')); // Ganti sesuai IP/server API

//     if (response.statusCode == 200) {
//       if (!mounted) return;
//       setState(() {
//         notifications = json.decode(response.body);
//       });
//     } else {
//       // Handle error
//     }
//   }

//   Future<void> deleteNotification(int id) async {
//     final response =
//         await http.delete(Uri.parse('$responseUrl/api/notifications/$id'));

//     if (response.statusCode == 200) {
//       fetchNotifications(); // Refresh list
//     } else {
//       // Handle error
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Notifikasi')),
//       body: ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           final notif = notifications[index];
//           return ListTile(
//             leading: Icon(Icons.notifications, color: Colors.amber),
//             title: Text(
//               notif['message'],
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Tipe: ${notif['notification_type']}'),
//                 Text('Waktu: ${notif['notification_time']}'),
//               ],
//             ),
//             trailing: IconButton(
//               icon: Icon(Icons.delete, color: Colors.red),
//               onPressed: () => deleteNotification(notif['id']),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_c14210052/constant/api_url.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List notifications = [];
  bool isLoading = true;

  Future<void> fetchNotifications() async {
    final response =
        await http.get(Uri.parse('$responseUrl/api/notifications'));

    if (response.statusCode == 200) {
      if (!mounted) return;
      setState(() {
        notifications = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteNotification(int id, int index) async {
    final response =
        await http.delete(Uri.parse('$responseUrl/api/notifications/$id'));

    if (response.statusCode == 200) {
      setState(() {
        notifications.removeAt(index);
      });

      // Tampilkan Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notifikasi berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus notifikasi'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Notifikasi'),
      //   backgroundColor: Colors.amber[700],
      //   centerTitle: true,
      // ),
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text("Tidak ada notifikasi"))
              : ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return Dismissible(
                      key: Key(notif['id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        deleteNotification(notif['id'], index);
                      },
                      child: Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          leading: Icon(Icons.notifications_active_rounded,
                              color: Colors.amber, size: 32),
                          title: Text(
                            notif['message'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tipe: ${notif['notification_type']}'),
                                Text('Waktu: ${notif['notification_time']}'),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () =>
                                deleteNotification(notif['id'], index),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
