// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       // appBar: AppBar(
//       //   title: Text("Profile"),
//       //   backgroundColor: Colors.blue,
//       //   centerTitle: true,
//       // ),
//       appBar: AppBar(
//         title: Text('Profile',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           // Bagian Atas (Profile Picture & Info)
//           Container(
//             color: Colors.grey[200],
//             padding: EdgeInsets.symmetric(vertical: 20),
//             child: Column(
//               children: [
//                 Stack(
//                   alignment: Alignment.bottomRight,
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[600],
//                       child: Icon(
//                         Icons.person,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                     CircleAvatar(
//                       radius: 15,
//                       backgroundColor: Colors.grey[500],
//                       child: Icon(
//                         Icons.camera_alt,
//                         size: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   "User One",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "user1@gmail.com",
//                   style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//                 ),
//               ],
//             ),
//           ),

//           // Bagian Settings
//           SizedBox(height: 10),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "Settings",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black54,
//               ),
//             ),
//           ),

//           // List Menu
//           Expanded(
//             child: Column(
//               children: [
//                 buildMenuItem(Icons.person, "Edit Profile"),
//                 buildMenuItem(Icons.lock, "Change Password"),
//                 buildMenuItem(Icons.favorite, "Favorite"),
//                 buildMenuItem(Icons.logout, "Log Out", isLogout: true),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget untuk item menu
//   Widget buildMenuItem(IconData icon, String text, {bool isLogout = false}) {
//     return Container(
//       color: Colors.white,
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: isLogout ? Colors.red : Colors.black54,
//         ),
//         title: Text(
//           text,
//           style: TextStyle(
//             fontSize: 16,
//             color: isLogout ? Colors.red : Colors.black87,
//             fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         onTap: () {
//           // Tambahkan navigasi atau aksi di sini
//         },
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ta_c14210052/constant/api_url.dart';
// import 'package:ta_c14210052/views/pages/app/best_seller_prediction.dart';
// import 'package:ta_c14210052/views/pages/app/favorite_page.dart';
// import 'edit_profile_page.dart';
// import 'change_password_page.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_c14210052/views/pages/auth/login_page.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String _namaUser = '';
//   String _emailUser = '';
//   String? _profileImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _loadDataUser();
//   }

//   Future<void> _pickAndUploadImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');

//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse('${responseUrl}/api/auth/user/update-profile-image'),
//       );
//       request.headers['Authorization'] = 'Bearer $token';
//       request.headers['Accept'] = 'application/json'; // <- Tambahkan ini!
//       request.files.add(await http.MultipartFile.fromPath(
//         'profile_image',
//         pickedFile.path,
//       ));

//       final response = await request.send();

//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         final data = json.decode(responseBody);
//         final imageUrl =
//             '${responseUrl}/storage/profile_images/${data['profile_image']}';

//         setState(() {
//           _profileImageUrl = imageUrl;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile image updated successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update profile image')),
//         );
//       }
//     }
//   }

//   // Future<void> _pickAndUploadImage() async {
//   //   final picker = ImagePicker();
//   //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   //   if (pickedFile != null) {
//   //     File imageFile = File(pickedFile.path);
//   //     final prefs = await SharedPreferences.getInstance();
//   //     final token = prefs.getString('token');

//   //     var request = http.MultipartRequest(
//   //       'POST',
//   //       Uri.parse('${responseUrl}/api/auth/upload-profile-image'),
//   //     );
//   //     request.headers['Authorization'] = 'Bearer $token';
//   //     request.files
//   //         .add(await http.MultipartFile.fromPath('image', imageFile.path));

//   //     var response = await request.send();
//   //     if (response.statusCode == 200) {
//   //       // Reload user data
//   //       _loadDataUser();
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text('Profile updated successfully.')),
//   //       );
//   //     } else {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text('Failed to upload image.')),
//   //       );
//   //     }
//   //   }
//   // }

//   Future<void> _loadDataUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       // _namaUser = prefs.getString('name') ?? 'Guest';
//       _namaUser = prefs.getString('namaUser') ?? 'Guest';
//       _emailUser = prefs.getString('emailUser') ?? 'guest@gmail.com';
//       // _profileImageUrl = prefs.getString('profileImage');
//       _profileImageUrl = '${responseUrl}/storage/profile_images/${prefs.getString('profileImage')}';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey[200],
//         appBar: AppBar(
//           title: const Text('Profile',
//               style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white)),
//           centerTitle: true,
//           backgroundColor: Colors.blue,
//         ),
//         body: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(children: [
//             // Bagian Atas (Profile Picture & Info)

//             Container(
//               color: Colors.grey[200],
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Column(
//                 children: [
//                   Stack(
//                     alignment: Alignment.bottomRight,
//                     children: [
//                       // CircleAvatar(
//                       //   radius: 50,
//                       //   backgroundColor: Colors.grey[600],
//                       //   child: const Icon(
//                       //     Icons.person,
//                       //     size: 50,
//                       //     color: Colors.white,
//                       //   ),
//                       // ),

//                       // CircleAvatar(
//                       //   radius: 50,
//                       //   backgroundColor: Colors.grey[600],
//                       //   backgroundImage: _profileImageUrl != null
//                       //       ? NetworkImage(
//                       //           '${responseUrl}/storage/profile_images/$_profileImageUrl')
//                       //       : null,
//                       //   child: _profileImageUrl == null
//                       //       ? const Icon(Icons.person,
//                       //           size: 50, color: Colors.white)
//                       //       : null,
//                       // ),

//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.grey[600],
//                         backgroundImage: _profileImageUrl != null
//                             ?
//                             // NetworkImage('${responseUrl}/storage/profile_images/$_profileImageUrl')
//                             NetworkImage(_profileImageUrl!)
//                             : null,
//                         child: _profileImageUrl == null
//                             ? Icon(
//                                 Icons.person,
//                                 size: 50,
//                                 color: Colors.white,
//                               )
//                             : null,
//                       ),

//                       // CircleAvatar(
//                       //   radius: 15,
//                       //   backgroundColor: Colors.grey[500],
//                       //   child: const Icon(
//                       //     Icons.camera_alt,
//                       //     size: 18,
//                       //     color: Colors.white,
//                       //   ),
//                       // ),

//                       // GestureDetector(
//                       //   onTap: _pickAndUploadImage,
//                       //   child: CircleAvatar(
//                       //     radius: 15,
//                       //     backgroundColor: Colors.grey[500],
//                       //     child: const Icon(
//                       //       Icons.camera_alt,
//                       //       size: 18,
//                       //       color: Colors.white,
//                       //     ),
//                       //   ),
//                       // ),

//                       GestureDetector(
//                         onTap: _pickAndUploadImage,
//                         child: CircleAvatar(
//                           radius: 15,
//                           backgroundColor: Colors.grey[500],
//                           child: const Icon(
//                             Icons.camera_alt,
//                             size: 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),

//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     _namaUser,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     _emailUser,
//                     style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//                   ),
//                 ],
//               ),
//             ),

//             // Bagian Settings
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               alignment: Alignment.centerLeft,
//               child: const Text(
//                 "Settings",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black54,
//                 ),
//               ),
//             ),

//             // List Menu
//             Container(
//               child: Column(
//                 children: [
//                   buildMenuItem(Icons.person, "Edit Profile", context,
//                       destination: EditProfilePage()),
//                   buildMenuItem(Icons.lock, "Change Password", context,
//                       destination: ChangePasswordPage()),
//                   buildMenuItem(Icons.favorite, "Favorite", context,
//                       destination: const FavoritePage()),
//                   buildMenuItem(Icons.shopping_basket_outlined,
//                       "Best Seller Product Prediction", context,
//                       destination: const BestSellerPrediction()),
//                   buildMenuItem(Icons.logout, "Log Out", context,
//                       isLogout: true),
//                 ],
//               ),
//             ),
//           ]),
//         ));
//   }

//   // Widget untuk item menu
//   // Widget buildMenuItem(IconData icon, String text, BuildContext context,
//   //     {bool isLogout = false, Widget? destination}) {
//   //   return Container(
//   //     color: Colors.white,
//   //     child: ListTile(
//   //       leading: Icon(
//   //         icon,
//   //         color: isLogout ? Colors.red : Colors.black54,
//   //       ),
//   //       title: Text(
//   //         text,
//   //         style: TextStyle(
//   //           fontSize: 16,
//   //           color: isLogout ? Colors.red : Colors.black87,
//   //           fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
//   //         ),
//   //       ),
//   //       onTap: () {
//   //         if (isLogout) {
//   //           // Implementasi Log Out
//   //           showDialog(
//   //             context: context,
//   //             builder: (context) => AlertDialog(
//   //               title: const Text("Log Out"),
//   //               content: const Text("Are you sure you want to log out?"),
//   //               actions: [
//   //                 TextButton(
//   //                   onPressed: () => Navigator.pop(context),
//   //                   child: const Text("Cancel"),
//   //                 ),
//   //                 TextButton(
//   //                   // onPressed: () {

//   //                   // },
//   //                   onPressed: () async {
//   //                     final prefs = await SharedPreferences.getInstance();
//   //                     final token = prefs.getString('token');

//   //                     if (token != null) {
//   //                       final response = await http.get(
//   //                         Uri.parse('${responseUrl}/api/auth/logout'),
//   //                         headers: {
//   //                           'Authorization': 'Bearer $token',
//   //                           'Accept': 'application/json',
//   //                         },
//   //                       );

//   //                       if (response.statusCode == 200) {
//   //                         await prefs.remove('token'); // hapus token
//   //                         Navigator.pushAndRemoveUntil(
//   //                           context,
//   //                           MaterialPageRoute(
//   //                               builder: (context) => const LoginPage()),
//   //                           (route) => false,
//   //                         );
//   //                       } else {
//   //                         Navigator.pop(context);
//   //                         ScaffoldMessenger.of(context).showSnackBar(
//   //                           const SnackBar(
//   //                               content: Text('Failed to logout. Try again.')),
//   //                         );
//   //                       }
//   //                     } else {
//   //                       Navigator.pop(context);
//   //                       ScaffoldMessenger.of(context).showSnackBar(
//   //                         const SnackBar(content: Text('No user logged in.')),
//   //                       );
//   //                     }
//   //                   },

//   //                   child: const Text("Log Out",
//   //                       style: TextStyle(color: Colors.red)),
//   //                 ),
//   //               ],
//   //             ),
//   //           );
//   //         } else if (destination != null) {
//   //           Navigator.push(
//   //             context,
//   //             MaterialPageRoute(builder: (context) => destination),
//   //           );
//   //         }
//   //       },
//   //     ),
//   //   );
//   // }

//   Widget buildMenuItem(IconData icon, String text, BuildContext context,
//       {bool isLogout = false, Widget? destination}) {
//     return Container(
//       color: Colors.white,
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: isLogout ? Colors.red : Colors.black54,
//         ),
//         title: Text(
//           text,
//           style: TextStyle(
//             fontSize: 16,
//             color: isLogout ? Colors.red : Colors.black87,
//             fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         onTap: () async {
//           if (isLogout) {
//             // Implementasi Log Out
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text("Log Out"),
//                 content: const Text("Are you sure you want to log out?"),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Cancel"),
//                   ),
//                   TextButton(
//                     // onPressed: () {

//                     // },
//                     onPressed: () async {
//                       final prefs = await SharedPreferences.getInstance();
//                       final token = prefs.getString('token');

//                       if (token != null) {
//                         final response = await http.get(
//                           Uri.parse('${responseUrl}/api/auth/logout'),
//                           headers: {
//                             'Authorization': 'Bearer $token',
//                             'Accept': 'application/json',
//                           },
//                         );

//                         if (response.statusCode == 200) {
//                           await prefs.remove('token'); // hapus token
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const LoginPage()),
//                             (route) => false,
//                           );
//                         } else {
//                           Navigator.pop(context);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Failed to logout. Try again.')),
//                           );
//                         }
//                       } else {
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('No user logged in.')),
//                         );
//                       }
//                     },

//                     child: const Text("Log Out",
//                         style: TextStyle(color: Colors.red)),
//                   ),
//                 ],
//               ),
//             );
//           } else if (destination != null) {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => destination),
//             );

//             if (result == 'updated') {
//               _loadDataUser(); // refresh data
//             }
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/views/pages/app/best_seller_prediction.dart';
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
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[600],
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : _profileImage != null
                                  ? NetworkImage(
                                          '$responseUrl/storage/profile_images/$_profileImage')
                                      as ImageProvider
                                  : null,
                          child:
                              (_selectedImage == null && _profileImage == null)
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    )
                                  : null,
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
                    buildMenuItem(Icons.shopping_basket_outlined,
                        "Best Seller Product Prediction", context,
                        destination: const BestSellerPrediction()),
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
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');

              if (token != null) {
                final response = await http.get(
                  Uri.parse('$responseUrl/api/auth/logout'),
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Accept': 'application/json',
                  },
                );

                if (response.statusCode == 200) {
                  await prefs.clear(); // Hapus semua data user
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to logout. Try again.')),
                  );
                }
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No user logged in.')),
                );
              }
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
