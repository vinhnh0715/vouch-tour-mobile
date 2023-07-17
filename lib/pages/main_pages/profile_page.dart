import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vouch_tour_mobile/pages/profile_pages/guideline_page.dart';
import 'package:vouch_tour_mobile/pages/profile_pages/information_profile_page.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  String? _userName;
  String? _userAvatarUrl;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final currentUser = await _googleSignIn.signInSilently();
      if (currentUser != null) {
        setState(() {
          _userName = currentUser.displayName;
          _userAvatarUrl = currentUser.photoUrl;
          _userEmail = currentUser.email;
        });
      }
    } catch (e) {
      // Handle sign-in errors
      print('Error loading user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightGreen, Colors.cyan],
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _userAvatarUrl != null
                            ? NetworkImage(_userAvatarUrl!)
                            : const AssetImage("") as ImageProvider<Object>,
                      ),
                    ),
                    child: _userAvatarUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName ?? 'Loading...',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userEmail ?? 'Loading...',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: ListTile(
                leading: const Icon(
                  Icons.account_circle_rounded,
                  size: 30,
                ),
                title: const Text('Thông tin cá nhân'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformationProfilePage(
                          tourGuideId: ApiService.currentUserId),
                    ),
                  );
                },
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: ListTile(
                leading: const Icon(
                  Icons.help,
                  size: 30,
                ),
                title: const Text('Hướng dẫn sử dụng'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuidelinePage(),
                    ),
                  );
                },
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  size: 30,
                ),
                title: const Text('Đăng xuất'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Logout functionality
                  _googleSignIn.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                iconColor: Colors.white,
                textColor: Colors.white,
                tileColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
