import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_response_model.dart';

class WeatherService {
  final String apiKey = '71ced824c06aeece5832d666f4f632a8';
  final String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeatherByCity(String city) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<Weather> fetchWeatherByCoordinates(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
