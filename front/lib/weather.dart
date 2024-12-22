import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _cityName = "Bengaluru";
  String _temperature = "";
  String _weatherDescription = "";

  Future<void> fetchWeather() async {
    final apiKey =
        "b2d464b352204492910211205242112"; // Replace with your API key from WeatherAPI
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
      } else {
        print("Failed to load weather data");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Weather App",
            style: TextStyle(fontFamily: 'head', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 5,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Weather in $_cityName",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      fontFamily: 'bdy'),
                ),
                SizedBox(height: 20),
                _temperature.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Text(
                            _temperature,
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontFamily: 'bdy'),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _weatherDescription,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade700,
                                fontFamily: 'bdy'),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: fetchWeather,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Refresh Weather",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigate back to the previous screen
                  },
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(WeatherApp());
}
