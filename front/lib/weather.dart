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
      home: Scaffold(
        appBar: AppBar(
          title: Text("Weather App"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Weather in $_cityName",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              _temperature.isEmpty
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        Text(
                          "Temperature: $_temperature",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "Condition: $_weatherDescription",
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back), // Back arrow icon
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back to the drawer
                          },
                        ),
                      ],
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchWeather,
                child: Text("Refresh Weather"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(WeatherApp());
}
