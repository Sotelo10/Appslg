import 'package:appslg/firebase_options.dart';
import 'package:appslg/src/pages/login_screen.dart';
import 'package:appslg/src/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  // Asegúrate de inicializar Firebase antes de ejecutar la aplicación
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splash", // La pantalla inicial, asegurándote de que coincida con las rutas
      routes: {
        "splash": (context) => const SplashScreen(), // Ruta para la pantalla de splash
        "home": (context) => LoginScreen(), // Ruta para la pantalla principal
      },
    );
  }
}
