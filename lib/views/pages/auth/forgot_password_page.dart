import 'package:flutter/material.dart';
import 'package:ta_c14210052/views/pages/auth/auth_service.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Forgot Password?")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Forgot Password?",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text("Enter your email to receive a verification code"),
            const SizedBox(height: 20),
            // const TextField(
            //   decoration: InputDecoration(
            //     hintText: "user@example.com",
            //     border: OutlineInputBorder(),
            //   ),
            // ),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "user@example.com",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child:
                  // ElevatedButton(
                  //   onPressed: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const ResetPasswordPage())),
                  //   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  //   child: const Text("Reset Password",
                  //       style: TextStyle(color: Colors.white)),
                  // ),

                  ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final success = await AuthService.sendResetEmail(email);
                  if (success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ResetPasswordPage(email: email)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Failed to send verification code.")));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Reset Password",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
