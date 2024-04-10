import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
      debugShowCheckedModeBanner:
          false, // Set debugShowCheckedModeBanner to false
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _weatherCondition = '';
  double _temperature = 0.0;
  String _cityName = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final apiKey = '6ffb3d788b4055253ae8dbf15c23c5e8';
    final lat = '60.1695';
    final lon = '24.9354';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _weatherCondition = jsonData['weather'][0]['main'];
          _temperature = jsonData['main']['temp'];
          _cityName = jsonData['name'];
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: _weatherCondition.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'City: $_cityName',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Current Weather: $_weatherCondition',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Temperature: $_temperature°C',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
