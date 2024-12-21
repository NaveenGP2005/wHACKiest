import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:whackiest/login.dart';

class Home extends StatefulWidget {
  final String name;
  final String email;

  Home({required this.name, required this.email});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  void _loadThemePreference() {
    final isDarkMode = html.window.localStorage['isDarkMode'] == 'true';
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    html.window.localStorage['isDarkMode'] = isDark.toString();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 229, 180, 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SWAP SAMBANDHA",
                      style: TextStyle(fontSize: 22, fontFamily: 'hi'),
                    ),
                    SizedBox(height: 20),
                    Icon(Icons.person_2_rounded, size: 30),
                    Text(widget.name),
                    Text(widget.email),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Home"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.menu_book),
                      title: Text("Personal Information"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_page),
                      title: Text("About Us"),
                      onTap: () {},
                    ),
                    SwitchListTile(
                      title: Text("Dark Mode"),
                      value: _themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        _toggleTheme(value);
                      },
                      secondary: Icon(
                        _themeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_rounded),
                      title: Text("Log out"),
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            title: Text(
              "SWAP SAMBANDA",
              style: TextStyle(
                fontFamily: 'hi',
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            bool isSmallScreen = screenWidth <= 600;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: isSmallScreen
                    ? Column(
                        children: [
                          ...[
                            'Are You A Buyer?',
                            'Are You A Seller?',
                            'Achievements',
                          ].map((text) {
                            return Column(
                              children: [
                                Container(
                                  width: screenWidth * 0.9,
                                  height: 220,
                                  padding: EdgeInsets.all(20.0),
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 107, 10, 3),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        text,
                                        style: TextStyle(
                                          fontFamily: 'hii',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          print("$text Button Clicked");
                                        },
                                        child: Text("Learn More"),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromARGB(
                                              255, 236, 244, 4),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 20.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ensure no overflow
                          children: [
                            ...[
                              'Are You A Buyer?',
                              'Are You A Seller?',
                              'Achievements',
                            ].map((text) {
                              return Container(
                                width: screenWidth * 0.3,
                                height: 220,
                                padding: EdgeInsets.all(20.0),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 107, 10, 3),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      text,
                                      style: TextStyle(
                                        fontFamily: 'hii',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        print("$text Button Clicked");
                                      },
                                      child: Text("Learn More"),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color.fromARGB(
                                            255, 236, 244, 4),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
