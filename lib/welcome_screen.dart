import 'package:flutter/material.dart';
import 'photo_screen.dart';
//TELA DE BOAS VINDAS
class WelcomeScreen extends StatelessWidget { //INÍCIO DAS ESPECIFICAÇÕES DA TELA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, //COR DO FUNDO
      /*appBar: AppBar(
        title: Text('Identificador de Plantas'),
      ),*/
      body: Center( //CENTRALIZA OS ELEMENTOS
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.asset("lib/assets/logo.png"),
            //TEXTO DE BOAS VINDAS
            Text(
              'Bem-vindo ao PlantaCheck!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white //COR DO TEXTO
              ),
            ),
            SizedBox(height: 20),
            //BOTÃO DE INICIAR
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhotoScreen()), //AO CLICAR ABRE A TELA DE CAPTURA DE IMAGEM
                );
              },
              child: Text(
                'Iniciar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700], //COR DO TEXTO
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}