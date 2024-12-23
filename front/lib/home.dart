import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:whackiest/login.dart';
import 'package:whackiest/next.dart';
import 'package:whackiest/weather.dart';

class Home extends StatefulWidget {
  final String name;
  final String email;

  Home({required this.name, required this.email});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ThemeMode _themeMode = ThemeMode.light;
  String _cityName = "London";
  String _temperature = "";
  String _weatherDescription = "";

  // Declare controllers here
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  get http => null;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    const String apiKey =
        "b2d464b352204492910211205242112"; // Replace with your API key
    final String apiUrl =
        "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$_cityName";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = "${data['current']['temp_c']}°C";
          _weatherDescription = data['current']['condition']['text'];
        });
      }
    } catch (e) {
      print("Error fetching weather: $e");
    }
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              // DrawerHeader with more polished UI
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 229, 180, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 15),
                    // User Name
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    // User Email
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
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
                      title: Text("Rewards"),
                      onTap: () {
                        // Navigate to the Rewards screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RewardsScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_page),
                      title: Text("About Us"),
                      onTap: () {
                        // Navigate to the About Us screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_page),
                      title: Text("Weather"),
                      onTap: () {
                        // Navigate to the About Us screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WeatherApp()),
                        );
                      },
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
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 231, 168, 104),
                                  Color.fromARGB(255, 240, 157, 157)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6.0,
                                  spreadRadius: 2.0,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Festivals Are Coming! Start the Countdown with Us!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ...['Are You A Buyer?', 'Are You A Seller?']
                              .map((text) {
                            return Container(
                              width: screenWidth * 0.9,
                              height: 220,
                              padding: const EdgeInsets.all(20.0),
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 242, 57, 44),
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    text,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'bdy',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyAppHome(
                                            nameController: nameController,
                                            priceController: priceController,
                                            imageController: imageController,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromARGB(
                                          255, 236, 244, 4),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 20.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text("Learn More"),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            SizedBox(width: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 231, 168, 104),
                                        Color.fromARGB(255, 240, 157, 157)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6.0,
                                        spreadRadius: 2.0,
                                        offset: const Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Festivals Are Coming! Start the Countdown with Us!',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...['Are You A Buyer?', 'Are You A Seller?']
                                    .map((text) {
                                  return Container(
                                    width: screenWidth * 0.3,
                                    height: 220,
                                    padding: const EdgeInsets.all(20.0),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 107, 10, 3),
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8.0,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          text,
                                          style: const TextStyle(
                                            fontFamily: 'hii',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MyAppHome(
                                                  nameController:
                                                      nameController,
                                                  priceController:
                                                      priceController,
                                                  imageController:
                                                      imageController,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 236, 244, 4),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10.0,
                                              horizontal: 20.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          child: const Text("Learn More"),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
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

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rewards", style: TextStyle(fontFamily: 'head')),
        centerTitle: true,
        backgroundColor: Colors.deepOrange, // Custom color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              "Your Available Rewards",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Rewards List Section
            Expanded(
              child: ListView(
                children: [
                  RewardCard(
                    rewardTitle: "Reward 1: 100 Points",
                    description: "Unlock special discounts and offers.",
                  ),
                  RewardCard(
                    rewardTitle: "Reward 2: 200 Points",
                    description: "Redeem for exclusive items in the shop.",
                  ),
                  RewardCard(
                    rewardTitle: "Reward 3: 500 Points",
                    description: "Get access to premium content.",
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Redeem Button Section
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle reward redemption logic
                },
                child: Text("Redeem Reward"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Card Widget for Rewards
class RewardCard extends StatelessWidget {
  final String rewardTitle;
  final String description;

  const RewardCard({
    required this.rewardTitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rewardTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("About Us", style: TextStyle(fontFamily: 'head'))),
      body: SingleChildScrollView(
        // Allow scrolling if content overflows
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("About SWAP SAMBANDA",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "bdy")),
            SizedBox(height: 20),
            Text(
              "SWAP SAMBANDA is a platform for swapping items and connecting buyers and sellers. Our mission is to provide a seamless trading experience with a focus on trust, security, and convenience.",
              style: TextStyle(fontSize: 18, fontFamily: 'bdy'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Meet Our Team:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Team Member 1
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Naveen G P",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'bdy')),
                        Text("Lead Developer",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Team Member 2
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.greenAccent,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("M P Pavan",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'bdy')),
                        Text("Designer & Sub-Developer",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Team Member 3
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.pinkAccent,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rajan S Shetti",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'bdy')),
                        Text("Marketing Director & Designer",
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Contact Us: randomemail@gmail.com",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'bdy'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Other classes (RewardsScreen, RewardCard, AboutUsScreen) remain unchanged.
