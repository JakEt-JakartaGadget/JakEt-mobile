import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/profile/models/profile_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreateProfilePage extends StatefulWidget {
  final UserData? userData;  // Menambahkan parameter userData ke konstruktor

  const CreateProfilePage({Key? key, this.userData}) : super(key: key);

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _profileNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data jika ada, jika tidak kosongkan
    _profileNameController = TextEditingController(text: widget.userData?.fields.profileName ?? '');
    _usernameController = TextEditingController(text: widget.userData?.fields.username ?? '');
    _phoneController = TextEditingController(text: widget.userData?.fields.phone ?? '');
    _emailController = TextEditingController(text: widget.userData?.fields.email ?? '');
    _aboutController = TextEditingController(text: widget.userData?.fields.about ?? '');
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

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
      final response = await request.post(
        'http://127.0.0.1:8000/profile/create/',
        {
          'profileName': _profileNameController.text,
          'username': _usernameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'about': _aboutController.text,
        },
      );

      if (response != null && response['status'] == 'success') {
        // Jika profil berhasil dibuat, navigasikan ke halaman profile
        Navigator.pop(context);
      } else {
        // Tampilkan pesan error jika gagal
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create profile.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
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
                    return 'Please enter your profile name';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aboutController,
                decoration: const InputDecoration(labelText: 'About'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please tell us something about yourself';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
