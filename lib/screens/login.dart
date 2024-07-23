import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_registration/screens/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  String? errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      await _login(email, password, autoLogin: true);
    }
  }

  Future<void> _saveLoginInfo(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> _clearLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  Future<void> _login(String email, String password,
      {bool autoLogin = false}) async {
    try {
      await _authentication.signInWithEmailAndPassword(
          email: email, password: password);
      if (!autoLogin) {
        await _saveLoginInfo(email, password);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful!"),
          duration: Duration(seconds: 3),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainBodyScreen()),
        );
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'user-not-found':
          errorMessage = "User not found";
          break;
        case 'wrong-password':
          errorMessage = "Wrong password";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email";
          break;
        case 'user-disabled':
          errorMessage = "User disabled";
          break;
        case 'too-many-requests':
          errorMessage = "Too many requests";
          break;
        default:
          errorMessage = "Invalid credentials";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (error) {
      errorMessage = error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController emailController = TextEditingController();
        final GlobalKey<FormState> key = GlobalKey<FormState>();

        Future<void> _resetPassword(String email) async {
          try {
            await _authentication.sendPasswordResetEmail(email: email);

            final Email emailMessage = Email(
              body: 'Please click the link below to reset your password:\n\n'
                  'Reset Link: [Reset Link]\n\n'
                  'Thank you!',
              subject: 'Password Reset Request',
              recipients: [email],
              attachmentPaths: ['assets/CodeFussion_Attachment.png'],
            );

            await FlutterEmailSender.send(emailMessage);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password reset email sent!"),
                duration: Duration(seconds: 3),
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context);
            });
          } on FirebaseAuthException catch (error) {
            String errorMessage = '';
            switch (error.code) {
              case 'user-not-found':
                errorMessage = "User not found";
                break;
              case 'invalid-email':
                errorMessage = "Invalid email";
                break;
              default:
                errorMessage = "Error occurred";
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                duration: const Duration(seconds: 5),
              ),
            );
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }

        String? emailValidator(String? email) {
          if (email == null || email.isEmpty) {
            return 'Please enter your email';
          } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
            return 'Please enter a valid email';
          }
          return null;
        }

        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/ForgotPasswordBG.png'),
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Positioned(
                top: 356,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 300,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Forgot Password",
                          style: GoogleFonts.dotGothic16(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Enter Email",
                            labelStyle: TextStyle(
                              color: Color.fromARGB(180, 255, 255, 255),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: emailValidator,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 145, 37, 218),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              final email = emailController.text;
                              _resetPassword(email);
                            }
                          },
                          child: const Text('Send Reset Code'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth * 0.95;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          const Positioned(
            left: -500,
            top: -500,
            child: Opacity(
              opacity: 0.2,
              child: Image(
                image: AssetImage('assets/Ellipse.png'),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            top: 250,
            child: Opacity(
              opacity: 0.2,
              child: Image(
                image: AssetImage('assets/Ellipse.png'),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/codewithfusion.png'),
                          width: imageWidth,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        "Login",
                        style: GoogleFonts.dotGothic16(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: key,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(180, 255, 255, 255),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                validator: emailValidator,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(180, 255, 255, 255),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                obscureText: true,
                                controller: passwordController,
                                validator: passwordValidator,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: _showForgotPasswordDialog,
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 145, 37, 218),
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (key.currentState!.validate()) {
                                    _login(emailController.text,
                                        passwordController.text);
                                  }
                                },
                                child: const Text('Login'),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MyRegistration(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Don't have an account? Sign up here!",
                                  style: GoogleFonts.dotGothic16(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
