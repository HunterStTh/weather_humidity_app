// Указываем, что этот файл является частью weather_bloc.dart
// Это необходимо для работы кодогенерации и связи между файлами
part of 'weather_bloc.dart';

// Абстрактный базовый класс для всех состояний погоды
// Наследуется от Equatable для правильного сравнения состояний
abstract class WeatherState extends Equatable {
  const WeatherState();  // Конструктор состояний

  @override
  // Определяем список свойств для сравнения состояний
  // Пустой список означает, что все состояния этого типа считаются равными
  List<Object> get props => [];
}

// Начальное состояние - когда приложение только запущено
// и еще не выполняло никаких действий
class WeatherInitial extends WeatherState {}

// Состояние загрузки - когда отправлен запрос на сервер
// и ожидается ответ
class WeatherLoading extends WeatherState {}

// Состояние успешной загрузки данных о погоде
class WeatherLoaded extends WeatherState {
  final WeatherData weatherData;  // Загруженные данные о погоде

  const WeatherLoaded(this.weatherData);  // Конструктор с обязательными данными

  @override
  // Определяем, что для сравнения используется weatherData
  List<Object> get props => [weatherData];
}

// Состояние с загруженной историей запросов
class WeatherHistoryLoaded extends WeatherState {
  final List<WeatherData> history;  // Список предыдущих запросов

  const WeatherHistoryLoaded(this.history);  // Конструктор с историей

  @override
  // Для сравнения используется список history
  List<Object> get props => [history];
}

// Состояние ошибки - когда что-то пошло не так
class WeatherError extends WeatherState {
  final String message;  // Текст ошибки для отображения пользователю

  const WeatherError(this.message);  // Конструктор с сообщением об ошибке

  @override
  // Для сравнения используется message
  List<Object> get props => [message];
}