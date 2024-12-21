import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/profile/models/profile_entry.dart';
import 'package:jaket_mobile/presentation/profile/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;

class EditProfilePage extends StatefulWidget {
  final UserData profileData;

  const EditProfilePage({super.key, required this.profileData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _profileName;
  late String _username;
  late int _phone;
  late String _email;
  late String _about;
  File? _profilePicture;
  String? _profilePictureWeb;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _profileName = widget.profileData.fields.profileName;
    _username = widget.profileData.fields.username;
    _phone = int.parse(widget.profileData.fields.phone);
    _email = widget.profileData.fields.email;
    _about = widget.profileData.fields.about;
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
        ..accept = 'image/*'
        ..click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files?.isEmpty ?? true) return;
        final reader = html.FileReader();
        reader.readAsDataUrl(files!.first);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _profilePictureWeb = reader.result as String;
            _profilePicture = null;
          });
        });
      });
    } else {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profilePicture = File(pickedFile.path);
          _profilePictureWeb = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gambar Profil
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profilePicture != null
                          ? FileImage(_profilePicture!)
                          : _profilePictureWeb != null
                              ? NetworkImage(_profilePictureWeb!) as ImageProvider
                              : const AssetImage("assets/default_profile.png"),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Choose Photo"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Form Data Profil
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personal Information",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    // Profile Name
                    TextFormField(
                      initialValue: _profileName,
                      decoration: InputDecoration(
                        labelText: "Profile Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _profileName = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Profile name tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Username
                    TextFormField(
                      initialValue: _username,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _username = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Username tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Phone
                    TextFormField(
                      initialValue: _phone.toString(),
                      decoration: InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _phone = int.tryParse(value!) ?? 0;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Phone tidak boleh kosong!";
                        }
                        final phoneNumber = int.tryParse(value);
                        if (phoneNumber == null) {
                          return "Phone harus berupa angka!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Email
                    TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _email = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // About
                    TextFormField(
                      initialValue: _about,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "About Me",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _about = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "About tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Tombol Simpan dengan desain yang diinginkan
                    Center(
                      child: Container(
                        width: 150, // Lebar tombol
                        height: 40, // Tinggi tombol
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF6D0CC9), // Warna awal gradien
                              Color(0xFF2E29A6), // Warna akhir gradien
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(50), // Radius tombol
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var formData = {
                                'profile_name': _profileName,
                                'username': _username,
                                'phone': _phone.toString(),
                                'email': _email,
                                'about': _about,
                                'profilePicture': _profilePicture != null
                                    ? base64Encode(_profilePicture!.readAsBytesSync())
                                    : _profilePictureWeb ?? "",
                              };

                              final response = await request.postJson(
                                "http://127.0.0.1:8000/profile/edit-flutter/",
                                jsonEncode(formData),
                              );

                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Profile berhasil diperbarui!"),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProfilePage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Gagal memperbarui profil!"),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16, // Ukuran font
                                fontWeight: FontWeight.bold, // Teks bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
