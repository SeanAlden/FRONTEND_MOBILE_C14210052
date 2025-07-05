import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/views/pages/app/favorite_page.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'package:ta_c14210052/views/pages/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _namaUser = '';
  String _emailUser = '';
  String? _profileImage;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadDataUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDataUser();
  }

  // Future<void> _loadDataUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _namaUser = prefs.getString('namaUser') ?? 'Guest';
  //     _emailUser = prefs.getString('emailUser') ?? 'guest@gmail.com';
  //     _profileImage = prefs.getString('profileImage'); // Load profile image
  //   });
  // }

  Future<void> _loadDataUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaUser = prefs.getString('namaUser') ?? 'Guest';
      _emailUser = prefs.getString('emailUser') ?? 'guest@gmail.com';
      _profileImage = prefs.getString('profileImage'); // Load profile image
    });

    // Memanggil endpoint untuk mendapatkan gambar profil
    final token = prefs.getString('token');
    final uri = Uri.parse('$responseUrl/api/auth/user/profile-image');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (!mounted) return;
      setState(() {
        _profileImage = data['profile_image'];
      });

      // await prefs.setString('profileImage', data['profile_image']);
      await prefs.setString('profileImage', data['profile_image'] ?? '');
      await prefs.reload();
    } else {
      if (!mounted) return;
      setState(() {
        _profileImage = null; // Atau bisa set ke gambar default
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _uploadImage(_selectedImage!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse('$responseUrl/api/auth/user/update-profile-image');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..files.add(await http.MultipartFile.fromPath(
        'profile_image',
        imageFile.path,
        filename: path.basename(imageFile.path),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);

      try {
        final data = json.decode(res.body);
        final imageFileName = data['profile_image'];

        if (mounted) {
          setState(() {
            _profileImage = imageFileName;
            _selectedImage = null;
          });

          // await prefs.setString('profileImage', imageFileName);
          // await prefs.reload();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully')),
          );
        }
      } catch (e) {
        debugPrint('Failed to parse JSON: ${res.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated'),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse('$responseUrl/api/auth/signout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Hapus token dan data user dari SharedPreferences
        await prefs.remove('token');
        await prefs.remove('user_id');
        await prefs.remove('namaUser');
        await prefs.remove('profileImage');

        // Navigasi ke halaman login atau welcome
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil logout!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal logout: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _loadDataUser();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Bagian Atas (Profile Picture & Info)
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // CircleAvatar(
                        //   radius: 50,
                        //   backgroundColor: Colors.grey[600],
                        //   backgroundImage: _selectedImage != null
                        //       ? FileImage(_selectedImage!)
                        //       : _profileImage != null
                        //           ? NetworkImage(
                        //                   '$responseUrl/storage/profile_images/$_profileImage')
                        //               as ImageProvider
                        //           : null,
                        //   child:
                        //       (_selectedImage == null && _profileImage == null)
                        //           ? const Icon(
                        //               Icons.person,
                        //               size: 50,
                        //               color: Colors.white,
                        //             )
                        //           : null,
                        // ),

                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[600],
                          child: _selectedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    _selectedImage!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : (_profileImage != null &&
                                      _profileImage!.isNotEmpty)
                                  ? ClipOval(
                                      child: Image.network(
                                        '$responseUrl/public/storage/profile_images/$_profileImage',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/profile.png',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey[500],
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _namaUser,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _emailUser,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),

              // Menu Items
              Container(
                child: Column(
                  children: [
                    buildMenuItem(Icons.person, "Edit Profile", context,
                        destination: const EditProfilePage()),
                    buildMenuItem(Icons.lock, "Change Password", context,
                        destination: const ChangePasswordPage()),
                    buildMenuItem(Icons.favorite, "Favorite", context,
                        destination: const FavoritePage()),
                    buildMenuItem(Icons.logout, "Log Out", context,
                        isLogout: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String text, BuildContext context,
      {bool isLogout = false, Widget? destination}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.black54,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isLogout ? Colors.red : Colors.black87,
            fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () async {
          if (isLogout) {
            _showLogoutDialog(context);
          } else if (destination != null) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );

            if (result == 'updated') {
              _loadDataUser();
            }
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: ()
                // async {
                //   final prefs = await SharedPreferences.getInstance();
                //   final token = prefs.getString('token');

                //   if (token != null) {
                //     final response = await http.get(
                //       Uri.parse('$responseUrl/api/auth/logout'),
                //       headers: {
                //         'Authorization': 'Bearer $token',
                //         'Accept': 'application/json',
                //       },
                //     );

                //     if (response.statusCode == 200) {
                //       await prefs.clear(); // Hapus semua data user
                //       Navigator.pushAndRemoveUntil(
                //         context,
                //         MaterialPageRoute(builder: (context) => const LoginPage()),
                //         (route) => false,
                //       );
                //     } else {
                //       Navigator.pop(context);
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //             content: Text('Failed to logout. Try again.')),
                //       );
                //     }
                //   } else {
                //     Navigator.pop(context);
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('No user logged in.')),
                //     );
                //   }
                // },
                {
              logoutUser();
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
