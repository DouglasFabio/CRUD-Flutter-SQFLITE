import 'package:flutter/material.dart';
import 'package:flutter_crud_sqlite/routes/app_routes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'CRUD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                child: Text('AUTENTICAR'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _authenticate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _authenticate() async {
    bool didAuthenticate = await _localAuth.authenticate(
      localizedReason: 'Por favor, autentique para continuar',
    );

    if (didAuthenticate) {
      ElegantNotification.success(
        title: Text('Sucesso!'),
        description: Text('Seja bem-vindo'),
        animation: AnimationType.fromTop,
      ).show(context);

      Navigator.of(context).pushNamed(AppRoutes.HOME_LIST);
    } else {
      ElegantNotification.error(
        title: Text('Erro!'),
        description: Text('Autenticação falhou, tente novamente'),
        animation: AnimationType.fromTop,
      ).show(context);
    }
  }
}
