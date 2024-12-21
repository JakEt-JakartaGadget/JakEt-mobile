import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/profile/edit_profile.dart';
import 'package:jaket_mobile/presentation/profile/models/profile_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'create_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<UserData?> fetchProfile(CookieRequest request) async {
    final response = await request.get('http://10.0.2.2:8000/profile/json/');
    debugPrint("Response: $response");

    final currentUser = request.jsonData['username'];

    var data = response;

    for (var d in data) {
      if (d != null && d['fields']['username'] == currentUser) {
        debugPrint("Matched user: ${d['fields']['username']}");
        return UserData.fromJson(d);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<UserData?>(
        future: fetchProfile(request),
        builder: (context, AsyncSnapshot<UserData?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching profile'));
          }

          if (snapshot.data == null) {
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CreateProfilePage()),
              );
            });
            return const Center(
                child: Text('No profile found, redirecting to profile creation...'));
          }

          final profile = snapshot.data!.fields;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          profile.profilePicture.isNotEmpty
                              ? 'http://10.0.2.2:8000/media/${profile.profilePicture}'
                              : 'assets/images/profile/blank-profile.jpg',
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          text: 'Hello ',
                          style: const TextStyle(
                            color: Colors.black, // Warna hitam
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: profile.profileName,
                              style: const TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: '!',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.username,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildProfileDetailRow('Profile Name', profile.profileName),
                        _buildProfileDetailRow('Username', profile.username),
                        _buildProfileDetailRow('Phone', profile.phone),
                        _buildProfileDetailRow('Email', profile.email),
                        _buildProfileDetailRow('About me', profile.about),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfilePage(profileData: snapshot.data!),
                        ),
                      );
                    },
                    child: Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6D0CC9), // Warna awal gradien
                            Color(0xFF2E29A6), // Warna akhir gradien
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white, // Warna teks
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
