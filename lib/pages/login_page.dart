import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/square_tile.dart';
import '../components/textfield.dart';
import '../components/button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
    );
    // pop loading circle
    Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      if (e.code == "user-not-found") {
        showErrorMessage("Email and password don't match");
        debugPrint("No user found for that email");
      } else if (e.code == "wrong-password") {
        showErrorMessage("Incorrect password");
        debugPrint("Incorrect password");
      }
    }
  }

  // log in error message popup
  void showErrorMessage(String message) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
      
                // logo 
                const Icon(
                  Icons.lock,
                  color: Colors.black,
                  size: 100,
                ),
                
                const SizedBox(height: 50),
      
                // welcome back, you've been missed!
                Text(
                  "Welcome back! You've been missed!",
                  style: TextStyle(color: Colors.grey[700],
                  fontSize: 16,
                  )
                ),
      
                const SizedBox(height: 25),
      
                // username text field
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                
                const SizedBox(height: 10),
      
                // password text field
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                
                const SizedBox(height: 10),
      
                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot your password?",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ]
                  ),
                ),
                
                const SizedBox(height: 10),
      
                // sign in button
                MyButton(
                  onTap: signUserIn,
                ),
                
                const SizedBox(height: 50),
      
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5, 
                          color: Colors.grey[400],
                        ),
                      ),
                
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(
                            color: Colors.grey[700]
                          ),  
                        ),
                      ),
                
                      Expanded(
                        child: Divider(
                          thickness: 0.5, 
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 50),
      
                // google & apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SquareTile(
                      imagePath: 'lib/images/google_logo.png'
                    ),
      
                    SizedBox(
                      width: 25,
                    ),
      
                    SquareTile(
                      imagePath: 'lib/images/apple_logo.png'
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
      
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4
                    ),
                    const Text(
                      "Register Now",
                      style: TextStyle(
                        color: Colors.blue, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}