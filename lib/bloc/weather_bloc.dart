import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:weather_humidity_app/models/weather_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weatherData = await _fetchWeather(event.city);
        final box = Hive.box<WeatherData>('weather_history');
        await box.put(weatherData.city, weatherData);
        emit(WeatherLoaded(weatherData));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });
    
    on<LoadWeatherHistory>((event, emit) async {
      final box = Hive.box<WeatherData>('weather_history');
      final history = box.values.toList();
      emit(WeatherHistoryLoaded(history));
    });
  }

  Future<WeatherData> _fetchWeather(String city) async {
   
    const apiKey = '9803baa707493c12375777f83fe90f69'; 
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherData(
        city: city,
        temperature: data['main']['temp'].toDouble(),
        humidity: data['main']['humidity'].toDouble(),
        description: data['weather'][0]['description'],
        windSpeed: data['wind']['speed'].toDouble(),
        timestamp: DateTime.now(),
      );
    } else {
      throw Exception('Ошибка загрузки температуры');
    }
  }
}