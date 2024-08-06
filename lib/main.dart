import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Adivinanza',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 9, 9, 9), // Fondo oscuro
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Courier New',
            fontSize: 18,
            color: Color(0xFFF5F5DC), // Color blanco hueso
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Courier New',
            fontSize: 18,
            color: Color(0xFFF5F5DC), // Color blanco hueso
          ),
        ),
      ),
      home: const Contador(),
    );
  }
}

class Contador extends StatefulWidget {
  const Contador({super.key});

  @override
  State<Contador> createState() => _ContadorEstado();
}

class _ContadorEstado extends State<Contador> {
  final TextEditingController numero = TextEditingController();
  int numeroAleatorio =
      Random().nextInt(25) + 1; // Genera un número aleatorio del 1 al 25
  int _contador = 0; // Contador de intentos
  bool mostrarTexto = false; // Controla la visibilidad del mensaje emergente
  bool juegoTerminado = false; // Controla si el juego ha terminado
  String mensaje = ''; // Mensaje que se mostrará
  List<int> lista = []; // Lista para almacenar los números ingresados
  bool _esVisible = true; // Controla la visibilidad del parpadeo del mensaje
  Timer? _temporizador; // Temporizador para el parpadeo del mensaje
  int _posicionMensaje = 0; // Posición actual del mensaje
  final List<Offset> _posiciones = [
    // Lista de posiciones predefinidas
    const Offset(5, 5), // Abajo
  ];

  void _incrementarContador() {
    setState(() {
      _contador++; // Incrementa el contador de intentos
    });
  }

  void _reiniciarJuego() {
    setState(() {
      numeroAleatorio =
          Random().nextInt(25) + 1; // Reinicia el número aleatorio
      _contador = 0; // Reinicia el contador de intentos
      mostrarTexto = false; // Oculta el mensaje emergente
      mensaje = ''; // Limpia el mensaje
      numero.text = ''; // Limpia el campo de texto
      lista.clear(); // Limpia la lista de números ingresados
      _temporizador?.cancel(); // Cancela el temporizador si está activo
      _esVisible = true; // Restablece la visibilidad del parpadeo
      _posicionMensaje = 0; // Restablece la posición del mensaje
      juegoTerminado = false; // Reinicia el estado del juego
    });
  }

  void _adivina() {
    if (_contador < 5 && !juegoTerminado) {
      _incrementarContador(); // Incrementa el contador de intentos
      var num =
          int.tryParse(numero.text); // Intenta convertir el texto a un número
      if (num != null) {
        lista.add(num); // Agrega el número a la lista
        if (num == numeroAleatorio) {
          mensaje = '¡Felicitaciones, ganaste!'; // Mensaje de victoria
          juegoTerminado = true; // Marca el juego como terminado
          _iniciarParpadeo(); // Inicia el parpadeo del mensaje
        } else if (_contador == 5) {
          mensaje =
              '¡Perdiste, sigue intentando. El número ganador era $numeroAleatorio!'; // Mensaje de pérdida
          juegoTerminado = true; // Marca el juego como terminado
          _iniciarParpadeo(); // Inicia el parpadeo del mensaje
        } else {
          mensaje = num < numeroAleatorio
              ? 'Tu número es menor'
              : 'Tu número es mayor'; // Mensaje de pista
        }
      } else {
        mensaje = 'Por favor, ingresa un número válido'; // Mensaje de error
        _iniciarParpadeo(); // Inicia el parpadeo del mensaje
      }
      setState(() {
        mostrarTexto = true; // Muestra el mensaje emergente
      });
      numero.text = ''; // Limpia el campo de texto

      // Mantener el enfoque en el campo de texto después de presionar Enter
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  void _iniciarParpadeo() {
    _temporizador?.cancel(); // Cancela el temporizador si está activo
    _temporizador =
        Timer.periodic(const Duration(milliseconds: 700), (temporizador) {
      setState(() {
        _esVisible =
            !_esVisible; // Alterna la visibilidad del mensaje para crear el efecto de parpadeo
        _posicionMensaje = (_posicionMensaje + 1) %
            _posiciones.length; // Cambia la posición del mensaje
      });
    });
  }

  @override
  void dispose() {
    _temporizador
        ?.cancel(); // Cancela el temporizador cuando el widget se destruye
    numero.dispose(); // Libera los recursos del controlador de texto
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Juego de Adivinanza',
            style: TextStyle(
              fontSize: 35,
              fontStyle: FontStyle.italic,
              color: Color(0xFFF5F5DC), // Color blanco hueso
            ),
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 57, 57, 57), // Color del AppBar
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                alignment: Alignment.center,
                child: const Image(
                  width: 140,
                  image: NetworkImage(
                      'https://yosoytuprofe.20minutos.es/wp-content/uploads/2023/03/adivinanzas-denumeros-1024x576.png?crop=1'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                child: const Center(
                  child: Text(
                    '¡Hola! \nSoy Jose Rosellon. \nhe pensado un número del 1 al 25 \n y te reto a que lo adivines en menos de 5 intentos.\n¡A JUGAR!',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: numero,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          hintText: "Ingresa tu número",
                          hintStyle: TextStyle(color: Colors.white)),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) =>
                          _adivina(), // Llama a la función cuando se presiona Enter
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: ElevatedButton(
                      onPressed:
                          _adivina, // Llama a la función para verificar el número
                      // ignore: sort_child_properties_last
                      child: const Text(
                        '¡Adivina!',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 56, 56, 56), // Color del botón
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Visibility(
                  visible: mostrarTexto,
                  child: Column(
                    children: <Widget>[
                      Text('Intento $_contador'),
                      Text(
                        mensaje,
                        style: TextStyle(
                          color: _esVisible
                              ? mensaje.contains(
                                      'Por favor, ingresa un número válido')
                                  ? Colors.red
                                  : mensaje.contains('¡Perdiste')
                                      ? Colors.yellow
                                      : mensaje.contains('¡Felicitaciones')
                                          ? Colors.green
                                          : Colors.white
                              : Colors.transparent,
                          fontWeight:
                              FontWeight.bold, // Hacer que el texto resalte
                          fontSize: 18, // Ajustar el tamaño de la fuente
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (lista.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Números ingresados:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        lista.join(', '),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              if (juegoTerminado)
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        onPressed: _reiniciarJuego, // Reinicia el juego
                        // ignore: sort_child_properties_last
                        child: const Text(
                          'Reiniciar juego',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 56, 56, 56), // Color del botón
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
