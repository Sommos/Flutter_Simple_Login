import 'package:firebase_auth/firebase_auth.dart';
import 'package:third_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/square_tile.dart';
import '../components/textfield.dart';
import '../components/button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});

  final Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // try creating the user
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
        );
      } else {
        // show error message
        showErrorMessage("Passwords do not match");
      }

    // pop loading circle
    Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      if(e.code == "user-not-found") {
        showErrorMessage("Email and password don't match");
        debugPrint("No user found for that email");
      } else if(e.code == "wrong-password") {
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
                  "Let's create an account for you!",
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

                // confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                
                const SizedBox(height: 10),
      
                // sign up button
                MyButton(
                  onTap: signUserUp,
                  message: "Sign up",
                ),
                
                const SizedBox(height: 20),
      
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.0, 
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
                          thickness: 1.0, 
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 20),
      
                // google & apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google_logo.png'
                    ),
      
                    const SizedBox(
                      width: 25,
                    ),
      
                    SquareTile(
                      onTap: () {},
                      imagePath: 'lib/images/apple_logo.png'
                    ),
                  ],
                ),
                
                const SizedBox(height: 15),
      
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Log in now",
                        style: TextStyle(
                          color: Colors.blue, 
                          fontWeight: FontWeight.bold,
                        ),
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