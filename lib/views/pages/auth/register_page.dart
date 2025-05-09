// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:ta_c14210052/views/auth/login_page.dart';

// class RegisterPage extends StatelessWidget {
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
//                   "Looks like you don't have an account. Let's create a new account for you."),
//               SizedBox(height: 20),
//               Text(
//                 "Sign Up",
//                 style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black),
//               ),
//               SizedBox(height: 10),
//               TextField(decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder())),
//               SizedBox(height: 20),
//               TextField(decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
//               SizedBox(height: 20),
//               TextField(
//                   obscureText: true,
//                   obscuringCharacter: '*',
//                   decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
//               SizedBox(height: 20),
//               TextField(
//                   obscureText: true,
//                   obscuringCharacter: '*',
//                   decoration: InputDecoration(labelText: "Confirm Password", border: OutlineInputBorder())),
//               SizedBox(height: 100),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   child: Text("Create Account",
//                       style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//               SizedBox(height: 40),
//               // Center(
//               //   child: GestureDetector(
//               //     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
//               //     child: Text("ALREADY HAVE ACCOUNT? Sign-in", style: TextStyle(color: Colors.blue)),
//               //   ),
//               // ),

//               Center(
//                 child: RichText(
//                   text: TextSpan(
//                     text: 'ALREADY HAVE ACCOUNT? ',
//                     style: TextStyle(color: Colors.black, fontSize: 16),
//                     children: [
//                       TextSpan(
//                         text: 'Sign-in',
//                         style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => LoginPage()),
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

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:ta_c14210052/views/pages/auth/login_page.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   bool _isObscurePassword = true; // Untuk input "Password"
//   bool _isObscureConfirmPassword = true; // Untuk input "Confirm Password"

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 50),
//               const Text(
//                 "Asia Raya Cashier",
//                 style: TextStyle(
//                     fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                   "Looks like you don't have an account. Let's create a new account for you."),
//               const SizedBox(height: 20),
//               const Text(
//                 "Sign Up",
//                 style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black),
//               ),
//               const SizedBox(height: 10),
//               const TextField(
//                 decoration: InputDecoration(
//                   labelText: "Full Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const TextField(
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Input untuk Password
//               TextField(
//                 obscureText: _isObscurePassword,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isObscurePassword ? Icons.visibility : Icons.visibility_off,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isObscurePassword = !_isObscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Input untuk Confirm Password
//               TextField(
//                 obscureText: _isObscureConfirmPassword,
//                 decoration: InputDecoration(
//                   labelText: "Confirm Password",
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isObscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isObscureConfirmPassword = !_isObscureConfirmPassword;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 100),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   child: const Text("Create Account",
//                       style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//               const SizedBox(height: 40),
//               Center(
//                 child: RichText(
//                   text: TextSpan(
//                     text: 'ALREADY HAVE ACCOUNT? ',
//                     style: const TextStyle(color: Colors.black, fontSize: 16),
//                     children: [
//                       TextSpan(
//                         text: 'Sign-in',
//                         style: const TextStyle(
//                             color: Colors.blue,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => LoginPage()),
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
import 'package:ta_c14210052/constant/api_url.dart';
import 'package:ta_c14210052/views/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  // Controllers untuk inputan user
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String errorMessage = '';
  String successMessage = '';

  // Ganti URL sesuai dengan Laravel kamu
  final String apiUrl =
      '$responseUrl/api/auth/register'; // untuk emulator Android

  // Future<void> registerUser() async {
  //   setState(() {
  //     errorMessage = '';
  //     successMessage = '';
  //   });

  //   if (_passwordController.text != _confirmPasswordController.text) {
  //     setState(() {
  //       errorMessage = 'Password dan Konfirmasi tidak sama!';
  //     });
  //     return;
  //   }

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'name': _nameController.text,
  //         'email': _emailController.text,
  //         'phone': _phoneController.text, // Tambahkan jika perlu
  //         'password': _passwordController.text,
  //         'password_confirmation': _confirmPasswordController.text,
  //         'usertype': 'cashier' // Sesuai backend kamu
  //       }),
  //     );

  //     final json = jsonDecode(response.body);
  //     // if (response.statusCode == 200 && json['success'] == true) {
  //     //   setState(() {
  //     //     successMessage = json['message'];
  //     //   });

  //     //   Navigator.pushReplacement(
  //     //       context, MaterialPageRoute(builder: (_) => const LoginPage()));

  //     //   // Redirect ke halaman login setelah sukses daftar
  //     //   // Future.delayed(const Duration(seconds: 2), () {

  //     //   // });
  //     // }

  //     if (response.statusCode == 200 && json['success'] == true) {
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (_) => const LoginPage()));
  //       // setState(() {
  //       //   successMessage = json['message'];
  //       // });

  //       // WidgetsBinding.instance.addPostFrameCallback((_) {
  //       //   Navigator.pushReplacement(
  //       //       context, MaterialPageRoute(builder: (context) => const LoginPage()));
  //       // });
  //     }
  //     else {
  //       setState(() {
  //         errorMessage = json['message'] ?? 'Gagal mendaftar.';
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Terjadi kesalahan: $e';
  //     });
  //   }
  // }

  Future<void> registerUser() async {
    setState(() {
      errorMessage = '';
      successMessage = '';
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Password dan Konfirmasi tidak sama!';
      });
      return;
    }

    // Tampilkan loading spinner
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text,
          'usertype': 'cashier',
        }),
      );

      final json = jsonDecode(response.body);

      // Tutup loading spinner
      // Navigator.of(context).pop();

      // if (response.statusCode == 200 && json['success'] == true) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //         content: Text(json['message']), backgroundColor: Colors.green),
      //   );

      //   await Future.delayed(
      //       const Duration(seconds: 2)); // Tunggu 2 detik biar user baca

      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (_) => const LoginPage()));
      // }

      Navigator.of(context).pop(); // Tutup dialog loading

      // if (response.statusCode == 200 && json['success'] == true) {
      if ((response.statusCode == 200 || response.statusCode == 201) && json['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(json['message']), backgroundColor: Colors.green),
        );

        // await Future.delayed(const Duration(seconds: 2));

        // Tunggu 1 frame dulu, supaya pop selesai
        // Future.microtask(() {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const LoginPage()),
        //   );
        // });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        setState(() {
          errorMessage = json['message'] ?? 'Gagal mendaftar.';
        });
      }
    } catch (e) {
      Navigator.of(context).pop(); // Pastikan close loading kalau error
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Asia Raya Cashier",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(height: 10),
              const Text(
                  "Looks like you don't have an account. Let's create a new account for you."),
              const SizedBox(height: 20),
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: _isObscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscurePassword = !_isObscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirmPassword = !_isObscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tampilkan pesan
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
              if (successMessage.isNotEmpty)
                Text(successMessage,
                    style: const TextStyle(color: Colors.green)),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Create Account",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'ALREADY HAVE ACCOUNT? ',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'Sign-in',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()));
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
    );
  }
}
