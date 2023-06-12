import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  // ...

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _userAvatarUrl != null
                      ? NetworkImage(_userAvatarUrl!)
                      : AssetImage("assets/images/facebook_logo.png")
                          as ImageProvider<Object>,
                ),
              ),
              child:
                  _userAvatarUrl == null ? Icon(Icons.person, size: 50) : null,
            ),
            SizedBox(height: 16),
            Text(
              _userName ?? 'Loading...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              _userEmail ?? 'Loading...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account Info'),
              onTap: () {
                // Navigate to account info page
                Navigator.pushNamed(context, '/account');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Logout functionality
                _googleSignIn.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
