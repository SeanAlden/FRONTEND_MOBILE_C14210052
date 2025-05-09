// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:ta_c14210052/views/auth/forgot_password_page.dart';
// import 'register_page.dart';

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 50),
//               Text(
//                 "Asia Raya Cashier",
//                 style: TextStyle(
//                     fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
//               ),
//               SizedBox(height: 10),
//               Text(
//                   "If you have an account, let's sign in. Else, go to sign up for creating a new account."),
//               SizedBox(height: 20),
//               Text(
//                 "Sign In",
//                 style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black),
//               ),
//               SizedBox(height: 10),
//               TextField(decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
//               SizedBox(height: 20),
//               TextField(
//                   obscureText: true,
//                   obscuringCharacter: '*',
//                   decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
//               SizedBox(height: 100),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   child: Text("Login", style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ForgotPasswordPage())),
//                     child: Text("Forgot Password?",
//                         style: TextStyle(color: Colors.blue)),
//                   ),

//                   // GestureDetector(
//                   //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
//                   //   child: Text("Sign-up", style: TextStyle(color: Colors.blue)),
//                   // ),
//                 ],
//               ),
//               SizedBox(height: 50),
//               Center(
//                 child: RichText(
//                   text: TextSpan(
//                     text: 'DON’T HAVE AN ACCOUNT? ',
//                     style: TextStyle(color: Colors.black, fontSize: 16),
//                     children: [
//                       TextSpan(
//                         text: 'Sign-up',
//                         style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => RegisterPage()),
//                             );
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/main.dart';
import 'package:ta_c14210052/views/pages/auth/forgot_password_page.dart';
import 'package:ta_c14210052/views/pages/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscurePassword = true;
  bool _isLoading = false;

  // Future<void> loginUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final response = await http.post(
  //     Uri.parse('${responseUrl}/api/auth/login'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'email': emailController.text.trim(),
  //       'password': passwordController.text,
  //     }),
  //   );

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   if (response.statusCode == 200) {
  //     final token = response.body;

  //     // Simpan token
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('token', token);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Login Berhasil!")),
  //     );

  //     // Arahkan ke Home (MainScreen)
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const MainScreen()),
  //     );
  //   } else {
  //     final error = jsonDecode(response.body);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error['message'] ?? "Login gagal")),
  //     );
  //   }
  // }

  // Future<void> loginUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final response = await http.post(
  //     Uri.parse('${responseUrl}/api/auth/login'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'email': emailController.text.trim(),
  //       'password': passwordController.text,
  //     }),
  //   );

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);

  //     final token = data[
  //         'token']; // Misal response berisi {"token": "...", "user": {"name": "..."}}
  //     final namaUser = data['user']['name']; // Ambil nama user dari response

  //     // Simpan token dan nama user ke SharedPreferences
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('token', token);
  //     await prefs.setString('namaUser', namaUser);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Login Berhasil!")),
  //     );

  //     // Arahkan ke Home (MainScreen)
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const MainScreen()),
  //     );
  //   } else {
  //     final error = jsonDecode(response.body);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error['message'] ?? "Login gagal")),
  //     );
  //   }
  // }

  // Future<void> loginUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final response = await http.post(
  //     Uri.parse('${responseUrl}/api/auth/login'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'email': emailController.text.trim(),
  //       'password': passwordController.text,
  //     }),
  //   );

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   if (response.statusCode == 200) {
  //     final token = response.body;

  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('token', token);

  //     // Karena tidak ada data user di response, kamu bisa ambil nama dari email misalnya
  //     final email = emailController.text.trim();
  //     final namaUser = email.split('@')[0]; // Contoh ekstrak nama dari email
  //     await prefs.setString('namaUser', namaUser);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Login Berhasil!")),
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const MainScreen()),
  //     );
  //   } else {
  //     final error = jsonDecode(response.body);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error['message'] ?? "Login gagal")),
  //     );
  //   }
  // }

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('$responseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final token = response.body;

      // Simpan token dulu
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Ambil semua user
      final usersResponse = await http.get(
        Uri.parse('$responseUrl/api/auth/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (usersResponse.statusCode == 200) {
        final usersData = jsonDecode(usersResponse.body);
        final List<dynamic> users = usersData['data'];

        // Cari user yang email-nya sesuai dengan input login
        final currentUser = users.firstWhere(
          (user) => user['email'] == emailController.text.trim(),
          orElse: () => null,
        );

        if (currentUser != null) {
          await prefs.setString('namaUser', currentUser['name']);
          // Tambahkan ini:
          await prefs.setInt(
              'user_id', currentUser['id']); // <--- ini yang wajib
          // await prefs.setString('profileImage', currentUser['profile_image']);
          await prefs.setString(
              'profileImage', currentUser['profile_image'] ?? '');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Login Berhasil!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
    // else {
    //   final error = jsonDecode(response.body);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(error['message'] ?? "Login gagal")),
    //   );
    // }

    else {
      final contentType = response.headers['content-type'];

      if (contentType != null && contentType.contains('application/json')) {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? "Login gagal")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Login gagal. Email atau password salah.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Asia Raya Cashier",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const SizedBox(height: 10),
                const Text("Welcome back! Please login to your account."),
                const SizedBox(height: 20),
                const Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: _isObscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscurePassword = !_isObscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : loginUser,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text("Login",
                            style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Center(
                //   child: Text(
                //     "Forgot Password?",
                //     style: TextStyle(
                //       color: Colors.indigo[400],
                //       fontWeight: FontWeight.bold, // Membuat teks tebal
                //     ),
                //   ),
                // ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.indigo[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'DON\'T HAVE AN ACCOUNT? ',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                          text: 'Sign-up',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
