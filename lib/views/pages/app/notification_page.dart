import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:intl/intl.dart';
import 'package:ta_c14210052/main.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List notifications = [];
  bool isLoading = true;

  Future<void> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      notificationCountNotifier.value = 0; // No token, no notifications
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$responseUrl/api/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (!mounted) return; // Check if the widget is still in the tree

      if (response.statusCode == 200) {
        setState(() {
          notifications = json.decode(response.body);
          isLoading = false;
        });
        // Update the global notifier with the current count
        notificationCountNotifier.value = notifications.length;
      } else {
        setState(() {
          isLoading = false;
        });
        notificationCountNotifier.value = 0; // Clear count on error
        debugPrint("Failed to fetch notifications: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      notificationCountNotifier.value = 0; // Clear count on error
      debugPrint("Error fetching notifications: $e");
    }
  }

  Future<void> deleteNotification(int id, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda belum login.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('$responseUrl/api/notifications/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (!mounted) return; // Check if the widget is still in the tree

      if (response.statusCode == 200) {
        setState(() {
          notifications.removeAt(index);
        });
        // Update the global notifier after deletion
        notificationCountNotifier.value = notifications.length;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifikasi berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus notifikasi: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error menghapus notifikasi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatLocalTime(String utcString) {
    try {
      DateTime utcTime = DateTime.parse(utcString).toUtc();
      
      DateTime jakartaTime = utcTime.add(const Duration(hours: 14));

      final DateFormat formatter = DateFormat("d MMMM yyyy HH.mm", "id_ID");

      return formatter.format(jakartaTime);
    } catch (e) {
      return utcString;
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
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text("Tidak ada notifikasi"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return Dismissible(
                      key: Key(notif['id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        deleteNotification(notif['id'], index);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          leading: const Icon(Icons.notifications_active_rounded,
                              color: Colors.amber, size: 32),
                          title: Text(
                            notif['message'],
                            style: const TextStyle(
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
                                Text(
                                    'Waktu: ${formatLocalTime(notif['notification_time'])}'),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
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