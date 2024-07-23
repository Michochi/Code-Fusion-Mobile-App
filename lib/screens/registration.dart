import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRegistration extends StatefulWidget {
  const MyRegistration({super.key});

  @override
  State<MyRegistration> createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<MyRegistration> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  final _key = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage = '';

  Future<void> _register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sign up Successful!"),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (error) {
      errorMessage = error.toString();
    }
  }

  String? _emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter a password';
    } else if (!RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(password)) {
      return 'Minimum eight characters, at least one letter, one number, and one special character';
    }
    return null;
  }

  String? _passwordValidator2(String? password2) {
    if (password2 == null || password2.isEmpty) {
      return 'Please confirm your password';
    } else if (_passwordController.text != _passwordController2.text) {
      return 'Confirm password must be the same';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  bool obscure = true;
  bool obscure1 = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageWidth = screenWidth * 0.95;
    double imageHeight = imageWidth * (9 / 16);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          const Positioned(
            left: -500,
            top: -600,
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
                          image: AssetImage('assets/codewithfusion.png'),
                          width: imageWidth,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        "Registration",
                        style: GoogleFonts.dotGothic16(
                            color: Colors.white, fontSize: 24),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                          key: _key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Enter Email",
                                  labelStyle: TextStyle(
                                      color:
                                          Color.fromARGB(180, 255, 255, 255)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 230, 0, 255)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: _emailValidator,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Enter Password",
                                  labelStyle: const TextStyle(
                                      color:
                                          Color.fromARGB(180, 255, 255, 255)),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 230, 0, 255)),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscure1 = !obscure1;
                                      });
                                    },
                                    icon: Icon(obscure1
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                controller: _passwordController,
                                obscureText: obscure1,
                                validator: _passwordValidator,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(180, 255, 255, 255)),
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 230, 0, 255)),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obscure = !obscure;
                                          });
                                        },
                                        icon: Icon(obscure
                                            ? Icons.visibility
                                            : Icons.visibility_off))),
                                controller: _passwordController2,
                                obscureText: obscure,
                                validator: _passwordValidator2,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Already signed in? Log in here',
                                  style: GoogleFonts.dotGothic16(
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 145, 37, 218),
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
                                  if (_key.currentState!.validate()) {
                                    _register(_emailController.text,
                                        _passwordController.text);
                                  }
                                },
                                child: const Text('Register'),
                              ),
                              const SizedBox(height: 20),
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
