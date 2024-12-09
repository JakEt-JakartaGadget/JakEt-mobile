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
  late Future<List<UserData>> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchProfile();
  }

  Future<List<UserData>> fetchProfile() async {
    final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
    final response = await request.get('http://127.0.0.1:8000/profile/json/');
    var data = response;

    List<UserData> listProfile = [];
    for (var d in data) {
      if (d != null) {
        listProfile.add(UserData.fromJson(d));
      }
    }
    return listProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<UserData>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching profile'));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Jika data kosong, arahkan ke halaman create profile
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CreateProfilePage()),
              );
            });
            return const Center(child: Text('No profile found, redirecting to profile creation...'));
          }

          final profile = snapshot.data!.first.fields;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile.profilePicture),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Hello ',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: profile.profileName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '!',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.username,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                _buildProfileDetailRow('Name', profile.profileName),
                _buildProfileDetailRow('Username', profile.username),
                _buildProfileDetailRow('Phone', profile.phone),
                _buildProfileDetailRow('Email', profile.email),
                _buildProfileDetailRow('About', profile.about),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add edit functionality here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(profileData: snapshot.data!.first),
                        ),
                      );
                    },
                    child: const Text('Edit'),
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
          Container(
            width: 100,
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
