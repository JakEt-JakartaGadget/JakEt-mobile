// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:jaket_mobile/presentation/authentication/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: Text(
                    'Create',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Your',
                      style: GoogleFonts.poppins(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'Account!',
                      style: GoogleFonts.poppins(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6D0CC9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60.0),
                Text(
                  'Username',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    color: const Color(0xFF6D0CC9),
                  ),
                ),
                const SizedBox(height: 4.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 141, 139, 139),
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Password',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    color: const Color(0xFF6D0CC9),
                  ),
                ),
                const SizedBox(height: 4.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 141, 139, 139),
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Password Confirmation',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    color:const Color(0xFF6D0CC9),
                  ),
                ),
                const SizedBox(height: 4.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 141, 139, 139),
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, 
                      shadowColor: Colors.transparent, 
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: _isLoading ? null : _handleRegister,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF985CEF),
                            Color(0xFF6D0CC9), 
                            Color(0xFF527EEE), 
                            Color(0xFF766DEE), 
                            Color(0xFF985CEF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 13.0,
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Text(
                        'Login here',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF2E29A6),
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final request = context.read<CookieRequest>();
    final response = await request.postJson(
      "http://10.0.2.2:8000/authenticate/register_app/",
      jsonEncode({
        "username": _usernameController.text,
        "password1": _passwordController.text,
        "password2": _confirmPasswordController.text,
      }),
    );

    if (response['status'] == 'success') {
      Get.snackbar(
        'Success',
        'Registration successful!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 1),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Get.off(() => const LoginPage());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register!')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

}
