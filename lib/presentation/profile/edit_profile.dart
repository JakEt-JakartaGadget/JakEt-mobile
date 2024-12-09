import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jaket_mobile/presentation/profile/models/profile_entry.dart'; // Untuk menggunakan json.encode

class EditProfilePage extends StatefulWidget {
  final UserData profileData;

  const EditProfilePage({super.key, required this.profileData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _profileNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _profileNameController = TextEditingController(text: widget.profileData.fields.profileName);
    _usernameController = TextEditingController(text: widget.profileData.fields.username);
    _phoneController = TextEditingController(text: widget.profileData.fields.phone);
    _emailController = TextEditingController(text: widget.profileData.fields.email);
    _aboutController = TextEditingController(text: widget.profileData.fields.about);
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'profile_name': _profileNameController.text,
        'username': _usernameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'about': _aboutController.text,
      };

      // URL API untuk memperbarui data (pastikan URL sesuai dengan endpoint backend Anda)
      final url = 'http://127.0.0.1:8000/profile/'; 

      // Mengirim request PUT atau PATCH untuk memperbarui data
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        // Jika update berhasil, kembali ke halaman sebelumnya (ProfilePage)
        Navigator.pop(context);
      } else {
        // Jika gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _profileNameController,
                decoration: const InputDecoration(labelText: 'Profile Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a profile name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _aboutController,
                decoration: const InputDecoration(labelText: 'About'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
