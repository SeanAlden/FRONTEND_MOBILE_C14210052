import 'package:flutter/material.dart';
import 'package:ta_c14210052/views/pages/auth/auth_service.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({super.key, required this.email});

  // const NewPasswordPage({super.key});

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool _isObscureNewPassword = true; // Untuk input "New Password"
  bool _isObscureConfirmPassword = true; // Untuk input "Confirm Password"

  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Set New Password",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text("Please make a password with at least 8 characters"),
            const SizedBox(height: 20),

            // Input untuk New Password
            TextField(
              controller: _newPassController,
              obscureText: _isObscureNewPassword,
              decoration: InputDecoration(
                labelText: "New Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureNewPassword = !_isObscureNewPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input untuk Confirm Password
            TextField(
              controller: _confirmPassController,
              obscureText: _isObscureConfirmPassword,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureConfirmPassword = !_isObscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
                width: double.infinity,
                child:
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    //   child: const Text("Reset Password",
                    //       style: TextStyle(color: Colors.white)),
                    // ),

                    ElevatedButton(
                  onPressed: () async {
                    final newPass = _newPassController.text;
                    final confirmPass = _confirmPassController.text;

                    if (newPass != confirmPass) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Passwords do not match")));
                      return;
                    }

                    final success = await AuthService.resetPassword(
                        widget.email, newPass, confirmPass);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Password successfully reset")));
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to reset password")));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Reset Password",
                      style: TextStyle(color: Colors.white)),
                )),
          ],
        ),
      ),
    );
  }
}
