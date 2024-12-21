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
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                    onTap: () {
                      // Add functionality if needed
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.menu_book),
                    title: Text("Personal Information"),
                    onTap: () {
                      // Add functionality if needed
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.contact_page),
                    title: Text("About Us"),
                    onTap: () {
                      // Add functionality if needed
                    },
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Pick Your Choice",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ...[
                'Are You A Buyer?',
                'Are You A Seller?',
                'Achievements',
              ].map((text) {
                return Column(
                  children: [
                    Container(
                      width: screenWidth * 0.8,
                      height: 220,
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 30.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 107, 10, 3),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: text,
                                  style: TextStyle(
                                    fontFamily: 'hii',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20), // Space between text and button
                          ElevatedButton(
                            onPressed: () {
                              print("$text Button Clicked");
                            },
                            child: Text("Learn More"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromARGB(255, 236, 244, 4),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20), // Consistent spacing between columns
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
