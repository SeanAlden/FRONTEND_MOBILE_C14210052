import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta_c14210052/views/pages/auth/auth_service.dart';
import 'package:ta_c14210052/views/pages/auth/new_password_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false;
  bool _canResend = false;
  int _secondsRemaining = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  // mengatur timer untuk mengirimkan ulang kode otp
  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 30;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() => _canResend = true);
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  // fungsi untuk mengecek kode yang di inputkan 
  Future<void> _verifyCode() async {
    final code = _controllers.map((e) => e.text).join();
    if (code.length == 4) {
      setState(() => _isLoading = true);
      final success = await AuthService.verifyOtp(widget.email, code);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPasswordPage(email: widget.email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid verification code.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Reset Password",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              "We already sent a verification code to ${widget.email}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Input kode verifikasi 4 digit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50,
                  child:
                      // TextField(
                      //   controller: _controllers[index],
                      //   focusNode: _focusNodes[index],
                      //   enabled: !_isLoading,
                      //   textAlign: TextAlign.center,
                      //   keyboardType: TextInputType.number,
                      //   maxLength: 1,
                      //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      //   decoration: const InputDecoration(
                      //     counterText: "",
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //   ],
                      //   onChanged: (value) {
                      //     if (value.isNotEmpty) {
                      //       if (index < 3) {
                      //         FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      //       } else {
                      //         _focusNodes[index].unfocus();
                      //         _verifyCode();
                      //       }
                      //     }
                      //   },
                      //   onSubmitted: (_) {
                      //     if (index == 3) {
                      //       _verifyCode();
                      //     }
                      //   },
                      //   onEditingComplete: () {},
                      //   onTap: () {
                      //     _controllers[index].selection = TextSelection.collapsed(
                      //         offset: _controllers[index].text.length);
                      //   },
                      //   onKey: (node, event) {
                      //     if (event.logicalKey == LogicalKeyboardKey.backspace &&
                      //         _controllers[index].text.isEmpty &&
                      //         index > 0) {
                      //       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                      //     }
                      //     return KeyEventResult.ignored;
                      //   },
                      // ),

                      RawKeyboardListener(
                    focusNode: FocusNode(), // FocusNode khusus untuk keyboard
                    onKey: (event) {
                      if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.backspace &&
                          _controllers[index].text.isEmpty &&
                          index > 0) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodes[index - 1]);
                      }
                    },
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      enabled: !_isLoading,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 3) {
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index + 1]);
                          } else {
                            _focusNodes[index].unfocus();
                            _verifyCode();
                          }
                        }
                      },
                      onSubmitted: (_) {
                        if (index == 3) _verifyCode();
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 70),

            _isLoading
                ? const CircularProgressIndicator()
                : const SizedBox(height: 20),

            const SizedBox(height: 20),

            // Resend Code Section
            Center(
              child: _canResend
                  ? RichText(
                      text: TextSpan(
                        text: 'Didn’t receive code? ',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Resend Code',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _startResendTimer();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Verification code resent.")),
                                );
                                // TODO: panggil 
                                AuthService.resendOtp(widget.email);
                              },
                          ),
                        ],
                      ),
                    )
                  : Text(
                      "Resend code in $_secondsRemaining seconds",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
