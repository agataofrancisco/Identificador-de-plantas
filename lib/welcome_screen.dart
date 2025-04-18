import 'package:flutter/material.dart';
import 'photo_screen.dart';
//TELA DE BOAS VINDAS
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
 //INÍCIO DAS ESPECIFICAÇÕES DA TELA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //COR DO FUNDO
      /*appBar: AppBar(
        title: Text('Identificador de Plantas'),
      ),*/
      body: Container(
        width: double.infinity,
        height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/foto-planta-1.png"),
          fit: BoxFit.cover
        )
      ),
        child: Center( //CENTRALIZA OS ELEMENTOS
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Image.asset("lib/assets/logo.png"),
              //TEXTO DE BOAS VINDAS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bem-vindo ao ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white //COR DO TEXTO
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(17)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'PlantaCheck!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreenAccent[700] //COR DO TEXTO
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
      ),
    );
  }
}