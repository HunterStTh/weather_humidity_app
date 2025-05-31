import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_humidity_app/bloc/weather_bloc.dart';
import 'package:weather_humidity_app/models/weather_model.dart';
import 'package:weather_humidity_app/models/calculation_model.dart';
import 'package:weather_humidity_app/screens/developer_screen.dart';
import 'package:weather_humidity_app/screens/home_screen.dart';
import 'package:weather_humidity_app/screens/calculations_screen.dart';
import 'package:weather_humidity_app/screens/camera_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherDataAdapter());
  Hive.registerAdapter(CalculationDataAdapter());
  await Hive.openBox<WeatherData>('weather_history');
  await Hive.openBox<CalculationData>('calculation_history');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Weather & Humidity App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        routes: {
          '/developer': (context) => const DeveloperScreen(),
          '/calculations': (context) => const CalculationsScreen(),
          '/camera': (context) => const CameraScreen(),
        },
      ),
    );
  }
}