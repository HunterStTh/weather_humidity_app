// Импорт необходимых библиотек
import 'dart:convert'; // Для работы с JSON
import 'package:bloc/bloc.dart'; // Основная библиотека BLoC
import 'package:equatable/equatable.dart'; // Для сравнения объектов
import 'package:http/http.dart' as http; // Для HTTP-запросов
import 'package:hive/hive.dart'; // Для локального хранилища
import 'package:weather_humidity_app/models/weather_model.dart'; // Модель данных погоды

// Импорт сгенерированных файлов с событиями и состояниями
part 'weather_event.dart';
part 'weather_state.dart';

// Основной класс BLoC для управления состоянием погоды
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  // Инициализация с начальным состоянием WeatherInitial
  WeatherBloc() : super(WeatherInitial()) {
    // Обработчик события FetchWeather (запрос погоды)
    on<FetchWeather>((event, emit) async {
      // Устанавливаем состояние загрузки
      emit(WeatherLoading());
      try {
        // Получаем данные о погоде
        final weatherData = await _fetchWeather(event.city);
        // Открываем Hive-бокс для хранения истории
        final box = Hive.box<WeatherData>('weather_history');
        // Сохраняем данные по ключу-названию города
        await box.put(weatherData.city, weatherData);
        // Устанавливаем состояние с загруженными данными
        emit(WeatherLoaded(weatherData));
      } catch (e) {
        // В случае ошибки устанавливаем состояние ошибки
        emit(WeatherError(e.toString()));
      }
    });
    
    // Обработчик события LoadWeatherHistory (загрузка истории)
    on<LoadWeatherHistory>((event, emit) async {
      // Открываем Hive-бокс
      final box = Hive.box<WeatherData>('weather_history');
      // Получаем все значения из хранилища
      final history = box.values.toList();
      // Устанавливаем состояние с загруженной историей
      emit(WeatherHistoryLoaded(history));
    });
  }

  // Приватный метод для выполнения запроса к API погоды
  Future<WeatherData> _fetchWeather(String city) async {
    // Ключ API для OpenWeatherMap
    const apiKey = '9803baa707493c12375777f83fe90f69';
    
    // Выполняем GET-запрос к API
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
    );

    // Если ответ успешный (код 200)
    if (response.statusCode == 200) {
      // Декодируем JSON-ответ
      final data = json.decode(response.body);
      
      // Создаем объект WeatherData из полученных данных
      return WeatherData(
        city: city, // Название города
        temperature: data['main']['temp'].toDouble(), // Температура
        humidity: data['main']['humidity'].toDouble(), // Влажность
        description: data['weather'][0]['description'], // Описание погоды
        windSpeed: data['wind']['speed'].toDouble(), // Скорость ветра
        timestamp: DateTime.now(), // Текущая дата/время
      );
    } else {
      // В случае ошибки выбрасываем исключение
      throw Exception('Ошибка загрузки температуры');
    }
  }
}