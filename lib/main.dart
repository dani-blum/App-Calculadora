import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = "0"; // Texto mostrado no visor
  String _currentInput = ""; // Entrada atual do usuário

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        _display = "0";
        _currentInput = "";
      } else if (value == "=") {
        _display = _calculateResult();
        _currentInput = _display;
      } else {
        if (_currentInput == "0") {
          _currentInput = value;
        } else {
          _currentInput += value;
        }
        _display = _currentInput;
      }
    });
  }

  String _calculateResult() {
    try {
      List<String> tokens = _currentInput.split(RegExp(r'(\D)')); // Divide entre números e operadores
      List<String> operators = _currentInput.split(RegExp(r'(\d+\.?\d*)')).where((e) => e.isNotEmpty).toList();

      double result = double.parse(tokens[0]);
      for (int i = 0; i < operators.length; i++) {
        double nextNum = double.parse(tokens[i + 1]);
        switch (operators[i]) {

          case '+':
            result += nextNum;
            break;
          case '-':
            result -= nextNum;
            break;
          case '*':
            result *= nextNum;
            break;
          case '/':
            if (nextNum != 0) {
              result /= nextNum;
            } else {
              return "Erro"; // Tratamento para divisão por zero
            }
            break;
        }
      }
      return result.toString();
    } catch (e) {
      return "Erro";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("Calculadora"),
        centerTitle: true,
        backgroundColor: Colors.pink[300],
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
          ),
          // Buttons
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.pink[100],
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  for (var button in [
                    "7", "8", "9", "/",
                    "4", "5", "6", "*",
                    "1", "2", "3", "-",
                    "C", "0", "=", "+"
                  ])
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _onButtonPressed(button),
                      child: Text(
                        button,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
