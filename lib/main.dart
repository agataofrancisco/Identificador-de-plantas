import 'package:flutter/material.dart';
import 'welcome_screen.dart';
//CÓDIGO PRINCIPAL
//FUNÇÃO INICIAL QUE O CÓDIGO COMEÇA
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Identificador de Plantas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      //CHAMA A TELA INICIAL DE BOAS VINDAS
      home: const WelcomeScreen(),
    );
  }
}