class Weather {
  final Main main;
  final List<WeatherCondition> weather;
  final Wind wind;
  final Clouds clouds;

  Weather({
    required this.main,
    required this.weather,
    required this.wind,
    required this.clouds,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: Main.fromJson(json['main']),
      weather: (json['weather'] as List).map((i) => WeatherCondition.fromJson(i)).toList(),
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
    );
  }
}

class Main {
  final double temp;
  final double tempMin;
  final double tempMax;
  final int humidity;

  Main({
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: (json['temp'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      humidity: json['humidity'] as int,
    );
  }
}

class WeatherCondition {
  final String main;
  final String description;

  WeatherCondition({
    required this.main,
    required this.description,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      main: json['main'],
      description: json['description'],
    );
  }
}

class Wind {
  final double speed;

  Wind({
    required this.speed,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json['speed'] as num).toDouble(),
    );
  }
}

class Clouds {
  final int all;

  Clouds({
    required this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }
}
