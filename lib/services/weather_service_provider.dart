import 'package:flutter/material.dart';
import 'package:weather/models/weather_response_model.dart';
import 'weather_service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeatherByCity(String city) async {
    _setLoadingState(true);

    try {
      _weather = await _weatherService.fetchWeatherByCity(city);
      _errorMessage = null;
    } catch (e) {
      _weather = null;
      _errorMessage = e.toString();
    }

    _setLoadingState(false);
  }

  Future<void> fetchWeatherByCoordinates(double latitude, double longitude) async {
    _setLoadingState(true);

    try {
      _weather = await _weatherService.fetchWeatherByCoordinates(latitude, longitude);
      _errorMessage = null;
    } catch (e) {
      _weather = null;
      _errorMessage = e.toString();
    }

    _setLoadingState(false);
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
