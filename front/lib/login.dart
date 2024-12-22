import 'package:flutter/material.dart';
import 'package:whackiest/home.dart'; // Ensure correct path to home.dart

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Create individual animations for each widget
    _slideAnimations = List.generate(
      3,
      (index) => Tween<Offset>(
        begin: Offset(0.0, 0.5), // Start slightly below the screen
        end: Offset.zero, // End at the original position
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve:
              Interval(0.2 * index, 0.2 * index + 0.3, curve: Curves.easeOut),
        ),
      ),
    );

    _fadeAnimations = List.generate(
      3,
      (index) => Tween<double>(
        begin: 0.0, // Fully transparent
        end: 1.0, // Fully visible
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve:
              Interval(0.2 * index, 0.2 * index + 0.3, curve: Curves.easeOut),
        ),
      ),
    );

    // Start animations after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(
            "Login",
            style: TextStyle(
              fontFamily: 'head',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF833ab4), // Purple
              Color(0xFFfd1d1d), // Red
              Color(0xFFfcb045), // Orange
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 69, 252, 243),
                    Color.fromARGB(255, 69, 252, 243),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ), // Slight transparency
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Username TextField
                    SlideTransition(
                      position: _slideAnimations[0],
                      child: FadeTransition(
                        opacity: _fadeAnimations[0],
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            suffixIcon: Icon(Icons.person,
                                color: const Color.fromARGB(255, 223, 216, 70)),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(230, 241, 239, 238)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Email TextField
                    SlideTransition(
                      position: _slideAnimations[1],
                      child: FadeTransition(
                        opacity: _fadeAnimations[1],
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            suffixIcon: Icon(Icons.email,
                                color: const Color.fromARGB(255, 19, 213, 238)),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.brown),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Password TextField
                    SlideTransition(
                      position: _slideAnimations[2],
                      child: FadeTransition(
                        opacity: _fadeAnimations[2],
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: Icon(Icons.remove_red_eye,
                                color: const Color.fromARGB(255, 195, 23, 201)),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.brown),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        if (_usernameController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                name: _usernameController.text,
                                email: _emailController.text,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('All fields are required!')),
                          );
                        }
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),

                    // Continue as Guest Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              name: 'Guest User',
                              email: 'guestuser@gmail.com',
                            ),
                          ),
                        );
                      },
                      child: Text('Continue as Guest User'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
