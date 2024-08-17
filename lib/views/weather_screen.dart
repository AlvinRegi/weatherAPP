import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/location_provider.dart';
import 'package:weather/services/weather_service_provider.dart';
import 'package:weather/views/image_path.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _clicked = true;
  final TextEditingController _searchController = TextEditingController();
  String location = "Unknown";
  String _searchedLocation = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).determinePosition();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locationProvider = Provider.of<LocationProvider>(context);

    if (_searchedLocation.isEmpty) {
      setState(() {
        location = locationProvider.currentLocationName?.locality ?? "Unknown";
      });
    }
  }

  Future<void> _refresh() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    setState(() {
      location = locationProvider.currentLocationName?.locality ?? "Unknown";
    });
  }

  String _getWeatherImage(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return imagepath[8];
      case 'thunderstorm':
        return imagepath[1];
      case 'clouds':
        return imagepath[2];
      case 'drizzle':
        return imagepath[3];
      case 'few clouds':
        return imagepath[4];
      case 'mist':
        return imagepath[5];
      case 'snow':
        return imagepath[6];
      case 'rain':
        return imagepath[7];
      default:
        return imagepath[8];
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    String weatherCondition =
        weatherProvider.weather?.weather.first.main ?? 'clear';

    // Date and time
    DateTime now = DateTime.now();
    String formattedDateTime =
        DateFormat('h:mm a - EEEE, d MMMM y').format(now);

    // Screen size
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEFAD50),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.3,
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.85,
                    child: Container(
                      height: height * 0.35,
                      width: width,
                      color: const Color(0xFFEFAD50),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.35,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: SizedBox(
                                  width: 200,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _clicked
                                              ? Text(
                                                  location,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )
                                              : SizedBox(
                                                  height: 30,
                                                  width: 150,
                                                  child: TextField(
                                                    controller:
                                                        _searchController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintStyle: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                      border: InputBorder.none,
                                                      hintText: "Search",
                                                      contentPadding:
                                                          EdgeInsets.all(0),
                                                    ),
                                                    cursorColor: Colors.white,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _clicked = !_clicked;
                                                if (!_clicked) {
                                                  _searchController.text = "";
                                                  _searchedLocation = "";
                                                } else {
                                                  _searchWeather();
                                                }
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.search_rounded),
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                        thickness: 0.5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${weatherProvider.weather?.main.temp ?? 'N/A'} °',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 70,
                                    ),
                                  ),
                                  Text(
                                    location,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    formattedDateTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.65,
                        width: width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    weatherProvider
                                            .weather?.weather.first.main ??
                                        'Not Found',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 100,
                                    child: Image.asset(
                                        _getWeatherImage(weatherCondition)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  // Temp max
                                  _buildWeatherDetailRow(
                                    'Temp Max',
                                    '${weatherProvider.weather?.main.tempMax ?? 'N/A'} °',
                                    'assets/images/redtemp.png',
                                  ),
                                  const SizedBox(height: 10),
                                  // Temp min
                                  _buildWeatherDetailRow(
                                    'Temp Min',
                                    '${weatherProvider.weather?.main.tempMin ?? 'N/A'} °',
                                    'assets/images/bluetemp.png',
                                  ),
                                  const SizedBox(height: 10),
                                  // Humidity
                                  _buildWeatherDetailRow(
                                    'Humidity',
                                    '${weatherProvider.weather?.main.humidity ?? 'N/A'}%',
                                    'assets/images/drop.png',
                                  ),
                                  const SizedBox(height: 10),
                                  // Cloudy
                                  _buildWeatherDetailRow(
                                    'Cloudy',
                                    '${weatherProvider.weather?.clouds.all ?? 'N/A'}%',
                                    null,
                                    icon: Icons.cloud_outlined,
                                  ),
                                  const SizedBox(height: 10),
                                  // Wind
                                  _buildWeatherDetailRow(
                                    'Wind',
                                    '${weatherProvider.weather?.wind.speed ?? 'N/A'} m/s',
                                    'assets/images/wind.png',
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 18.0, right: 18, top: 10),
                              child: Divider(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _searchWeather() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      await Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeatherByCity(query);
      setState(() {
        location = query;
        _searchedLocation = query;
      });
    }
  }

  Widget _buildWeatherDetailRow(String label, String value, String? imagePath,
      {IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            if (imagePath != null) ...[
              const SizedBox(width: 8),
              Image.asset(
                imagePath,
                height: 24,
                width: 24,
              ),
            ],
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
