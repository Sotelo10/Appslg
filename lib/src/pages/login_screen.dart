import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF0066CC),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFFFDF00)),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFFFDF00), // Botón amarillo
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 30, // Aumenté el tamaño de la fuente
            fontWeight: FontWeight.w700,
            fontFamily: 'Roboto', // Fuente más profesional
          ),
          bodyLarge: TextStyle(
            fontSize: 18, // Aumenté el tamaño de la fuente
            fontFamily: 'Roboto',
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? _errorMessage;

  // Método de inicio de sesión con Google
  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión con el token de Google
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final String? email = userCredential.user?.email;

      if (email != null && email.endsWith('@unica.edu.pe')) {
        print('Logged in as: ${userCredential.user?.displayName}');
        // Redirigir al usuario a PartScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PartScreen()),
        );
      } else {
        // Si el correo no termina en @unica.edu.pe, mostrar un error
        setState(() {
          _errorMessage = 'Solo se permite el acceso con un correo @unica.edu.pe';
        });
        _auth.signOut();  // Opcional: cerrar sesión si no es un correo válido
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFDF00), // Fondo amarillo
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen superior
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'), // Cambia esto a tu imagen
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40), // Espacio más grande entre la imagen y el título
              // Título y texto de bienvenida
              Text(
                'Bienvenido a la App',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.black),
              ),
              SizedBox(height: 30), // Mayor espacio entre el título y el texto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Inicia sesión con tu cuenta de Google para continuar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black87),
                ),
              ),
              SizedBox(height: 50), // Más espacio antes del botón
              // Botón de inicio de sesión con Google
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  onPressed: _loginWithGoogle,
                  icon: Icon(Icons.login, color: Colors.black),
                  label: Text(
                    'Iniciar sesión con Google',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.3), // Sombra en el botón
                  ),
                ),
              ),
              SizedBox(height: 30), // Más espacio después del botón
              // Mensaje de error (si existe)
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Error: $_errorMessage',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// PartScreen: Pantalla a la que se redirige después de iniciar sesión correctamente
class PartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido a la pantalla principal!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la acción que deseas realizar en la pantalla principal
                print('Acción en la pantalla principal');
              },
              child: Text('Realizar acción'),
            ),
          ],
        ),
      ),
    );
  }
}
