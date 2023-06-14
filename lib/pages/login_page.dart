import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vouch_tour_mobile/services/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  bool _isLoading = false; // Track the loading state

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true when login starts
      });

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String email = user.email!;
        final String jwtToken = await ApiService.fetchJwtToken(email);
      }

      setState(() {
        _isLoading = false; // Set loading state to false when login is done
      });

      return userCredential;
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading state to false in case of an error
      });
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // Future<UserCredential?> signInWithFacebook() async {
  //   try {
  //     setState(() {
  //       _isLoading = true; // Set loading state to true when login starts
  //     });

  //     final LoginResult loginResult = await FacebookAuth.instance.login();

  //     if (loginResult.status == LoginStatus.success) {
  //       final OAuthCredential credential =
  //           FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //       final UserCredential userCredential =
  //           await FirebaseAuth.instance.signInWithCredential(credential);

  //       setState(() {
  //         _isLoading = false; // Set loading state to false when login is done
  //       });

  //       return userCredential;
  //     } else if (loginResult.status == LoginStatus.cancelled) {
  //       setState(() {
  //         _isLoading =
  //             false; // Set loading state to false if login is cancelled
  //       });
  //       print('Facebook login cancelled');
  //       return null;
  //     } else {
  //       setState(() {
  //         _isLoading = false; // Set loading state to false if login fails
  //       });
  //       print('Facebook login failed');
  //       return null;
  //     }
  //   } catch (e, stackTrace) {
  //     setState(() {
  //       _isLoading = false; // Set loading state to false in case of an error
  //     });
  //     print('Error during Facebook login: $e');
  //     print(stackTrace); // Print the stack trace for further analysis
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/images/tour_logo.png",
                width: 250,
                height: 150,
              ),
              SizedBox(height: 20),
              _isLoading // Check the loading state to show loading indicator or login buttons
                  ? CircularProgressIndicator() // Show loading indicator
                  : Container(
                      width: 200,
                      height: 50, // Adjust the width as needed
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _signInWithGoogle().then((userCredential) {
                            if (userCredential != null) {
                              // Login successful, navigate to HomePage
                              Navigator.pushNamed(context, "/home");
                            } else {
                              // Error signing in, display an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Failed to sign in with Google."),
                                ),
                              );
                            }
                          });
                        },
                        icon: Image.asset(
                          "lib/assets/images/google_logo.png",
                          width: 24,
                          height: 24,
                        ),
                        label: Text(
                          "Login with Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
